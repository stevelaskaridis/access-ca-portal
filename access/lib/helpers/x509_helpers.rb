class X509Helpers
  def self.valid_csr?(csr)
    begin
      CertificateAuthority::SigningRequest.from_x509_csr(csr)
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
end