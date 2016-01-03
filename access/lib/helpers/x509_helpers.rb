require 'open-uri'

class X509Helpers

  ############################ CSR related ############################
  #####################################################################
  def self.valid_csr?(csr)
    begin
      if csr
        CertificateAuthority::SigningRequest.from_x509_csr(csr)
      else
        return false
      end
    rescue OpenSSL::X509::RequestError
      return false
    end
    return true
  end

  def self.valid_spkac_csr?(body)
    info, spkac = body.split(/SPKAC=/)
    begin
      if spkac
        CertificateAuthority::SigningRequest.from_netscape_spkac(spkac)
      else
        return false
      end
    end
    true
  end

  def self.csr_creation(certificate_request, params)
    begin
      csr = CertificateAuthority::SigningRequest.from_x509_csr(params['certificate_request']['body'])
      dn = DistinguishedName.find_by_subject_dn(csr.distinguished_name.x509_name.to_s)
      unless dn
        dn = DistinguishedName.new(owner_id: params[:owner_id],
                                   subject_dn: csr.distinguished_name.x509_name.to_s.split('/subjectAltName')[0],
                                   owner_type: 'Person')
        dn.save!()
      end
      certificate_request.owner_dn = dn
      certificate_request.uuid = SecureRandom.hex(10)
      certificate_request.csr_type = 'classic'
      org = Organization.find_by_domain(csr.distinguished_name.organizational_unit)
      if org
        certificate_request.organization = org
      else
        raise Exception()
      end
      certificate_request.status = 'pending'
    rescue OpenSSL::X509::RequestError
      return
    end
  end

  def self.csr_spkac_creation(certificate_request, params)
    begin
    spkac = params[:SPKAC].gsub(/\n/, '').gsub(/\r/, '')
    csr = CertificateAuthority::SigningRequest.from_netscape_spkac(spkac)
    subject_dn = ['/C='+params[:countryName],'O='+params[:organizationName],
                  'OU='+params[:organizationalUnitName],'CN='+params[:commonName]].join("/")
    csr.distinguished_name = subject_dn
    dn = DistinguishedName.find_by_subject_dn(subject_dn)
    unless dn
      dn = DistinguishedName.new(owner_id: params[:user_id],
                                 subject_dn: subject_dn,
                                 owner_type: 'Person')
      dn.save!

    end
    certificate_request.owner_dn = dn
    certificate_request.uuid = SecureRandom.hex(10)
    certificate_request.csr_type = 'spkac'
    certificate_request.body = subject_dn + "/SPKAC=#{spkac}"
    org = Organization.find_by_domain(dn.subject_dn.split('/')[3].split('OU=')[1])
    if org
      certificate_request.organization = org
    else
      raise Exception()
    end
    certificate_request.status = 'pending'
    rescue OpenSSL::X509::RequestError

    end
  end

  # Certificate Reader is a class because it has to monitor CRLs as a field as well.

  class CertificateReader
    attr_reader :certificate_obj
    def initialize(certificate_body, crl="")
      if crl != ""
        crl_body = crl
      else
        # The certificate_openssl var is used as an intermediary step for reading the whole
        # info ouput saved in the XML record body.
        certificate_openssl = OpenSSL::X509::Certificate.new(certificate_body)
        @certificate_obj = CertificateAuthority::Certificate.from_x509_cert(certificate_openssl)
        ca_hash = @certificate_obj.openssl_body.issuer.hash.to_s(base=16)
        crl_file = Dir.tmpdir + "/" + ca_hash + ".crl"
        check_crl = true
        if File.exist?(crl_file) and (Time.now.to_i - open(crl_file).stat.ctime.to_i) < 10
          crl_body = open(crl_file).read
        else
          crl_url = APP_CONFIG['CA']['crl_distribution_point'][ca_hash] || "#{Rails.root}/crl.pem"
          tmp_crl = nil
          begin
            crl_body = open(crl_url).read
            tmp_crl = File.open(crl_file, "w")
            tmp_crl.print crl_body
          rescue
            check_crl = false
          ensure
            tmp_crl.close unless tmp_crl.nil?
          end
        end
      end
      # Check with CRL
      if check_crl
        crl = OpenSSL::X509::CRL.new(crl_body)
        @serials = Array.new
        crl.revoked.each do |rev|
          @serials << rev.serial
        end
      end
    end

    def get_certificate_status
      status = 'valid'
      @now = Time::now.to_i
      if @serials.include? @certificate_obj.openssl_body.serial
        status = 'revoked'
      elsif @certificate_obj.not_after.to_i < @now
        status = 'expired'
      end
      status
    end

  end


  private
  @@signing_profile = {
      "extensions" => {
          "basicConstraints" => {"ca" => false},
          "crlDistributionPoints" => {"uri" => "#{APP_CONFIG['CA']['signing']['crl_distribution_point']}"},
          "subjectKeyIdentifier" => {},
          "authorityKeyIdentifier" => {},
          "authorityInfoAccess" => {"ocsp" => ["#{APP_CONFIG['CA']['signing']['ocsp_endpoint']}"]},
          "keyUsage" => {"usage" => APP_CONFIG['CA']['signing']['key_usages']},
          "extendedKeyUsage" => {"usage" => APP_CONFIG['CA']['signing']['extended_key_usages']},
          "subjectAltName" => {"uris" => [""]},
          "certificatePolicies" => {
              "policy_identifier" => "#{APP_CONFIG['CA']['signing']['policy_id']}", "cps_uris" => APP_CONFIG['CA']['signing']['cps_uris'],
              "user_notice" => {
                  "explicit_text" => "#{APP_CONFIG['CA']['signing']['user_notice']['explicit_text']}",
                  "organization" => "#{APP_CONFIG['CA']['signing']['user_notice']['organization']}",
                  "notice_numbers" => "#{APP_CONFIG['CA']['signing']['user_notice']['notice_numbers']}"
              }
          }
      }
  }

  ######################## Certificate signing related ########################
  #############################################################################

  def self.sign_csr(csr, ca_cert)
    cert_to_sign = CertificateAuthority::SigningRequest.from_x509_csr(csr).to_cert
    cert_to_sign = CertificateAuthority::Certificate.from_x509_cert(ca_cert)
    cert_to_sign.parent = ca_cert
    cert_to_sign.sign!(@@signing_profile)
    cert_to_sign.key_material.public_key
  end

  def self.valid_cert?(certificate)
    begin
      if certificate
        dummy_private_key = OpenSSL::PKey::RSA.new(1024)
        cert = CertificateAuthority::Certificate.from_x509_cert(certificate)
        cert.instance_eval do
          self.key_material.private_key = dummy_private_key
        end
        return cert.valid?
      else
        return false
      end
    rescue OpenSSL::X509::CertificateError
      return false
    end
  end
end