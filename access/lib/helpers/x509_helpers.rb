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

  def self.csr_creation(certificate_request, params)
    begin
      csr = CertificateAuthority::SigningRequest.from_x509_csr(params['certificate_request']['body'])
      dn = DistinguishedName.find_by_subject_dn(csr.distinguished_name.x509_name.to_s)
      if dn
        certificate_request.owner_dn = dn
      else
        dn = DistinguishedName.new(owner_id: params[:owner_id],
                                   subject_dn: csr.distinguished_name.x509_name.to_s,
                                   owner_type: :person)
        dn.save()
      end
      certificate_request.owner_dn = dn
      certificate_request.requestor = Person.find(params[:owner_id])
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

  private
  @@signing_profile = {
      "extensions" => {
          "basicConstraints" => {"ca" => false},
          "crlDistributionPoints" => {"uri" => "#{APP_CONFIG['CA']['crl_distribution_point']}"},
          "subjectKeyIdentifier" => {},
          "authorityKeyIdentifier" => {},
          "authorityInfoAccess" => {"ocsp" => ["#{APP_CONFIG['CA']['ocsp_endpoint']}"]},
          "keyUsage" => {"usage" => APP_CONFIG['CA']['key_usages']},
          "extendedKeyUsage" => {"usage" => APP_CONFIG['CA']['extended_key_usages']},
          "subjectAltName" => {"uris" => [""]},
          "certificatePolicies" => {
              "policy_identifier" => "#{APP_CONFIG['CA']['policy_id']}", "cps_uris" => APP_CONFIG['CA']['cps_uris'],
              "user_notice" => {
                  "explicit_text" => "#{APP_CONFIG['CA']['user_notice']['explicit_text']}",
                  "organization" => "#{APP_CONFIG['CA']['user_notice']['organization']}",
                  "notice_numbers" => "#{APP_CONFIG['CA']['user_notice']['notice_numbers']}"
              }
          }
      }
  }

  ######################## Certificate related ########################
  #####################################################################
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