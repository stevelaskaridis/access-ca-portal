require 'test_helper'

class CertificateRequestTest < ActiveSupport::TestCase
  def valid_params
    {
        status: 'pending',
        comments: '',
        body: "-----BEGIN CERTIFICATE REQUEST-----
MIICkjCCAXoCAQAwTTELMAkGA1UEBhMCR1IxEzARBgNVBAoTCkhlbGxhc0dyaWQx
EDAOBgNVBAsTB2F1dGguZ3IxFzAVBgNVBAMTDkpvaG4gQXBwbGVzZWVkMIIBIjAN
BgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAtvSSIq4T2ndJ6nFA84eN1VTqUut1
s42CHc1NxJZiM1rwrkJESEt4pCS2Wc1sDbKUYEGRvpvgkcGpl1zEMNNsL9rOuN6g
lF8LrzAgcLuXZMCv5Oov1rqBU/pvnsMClYP5Qni6LgxwBm5y+31LocNTxhoXsRLp
Da0tITv9O3dPeTEt4kIn6oRSR9vIcJ5dX+QrtEBNPCb7+BRZXz3phLDYeqEt7ziH
UzWyibnvWVrTN5gtcjso1yph2YvhLivvrxSu3qCFgzkZySe8DJs8K7koxGeJlG32
a3//RCE3mRr/yvdMPJdWwobvaAWUtQ8zpXdBIasuq2okOpAp2If82VphYwIDAQAB
oAAwDQYJKoZIhvcNAQEFBQADggEBAEWTtxkXtcqA8nDoYIhdo9kCovSGXHY9SmCd
Zw7ffSXll8hZHMcBtbdr2KQwacFE0Kd3Ow2+gEMDIG/riCDzlwYbFP//RB7gMFsJ
1gxNAl664Xnd2QsYRJ2OwnvlSTtliGlSyULdx1OxlFkw06XDJPozQNmVIw9uUn7D
CFpjbZnYKJj2/fXNf22Y38B3LNQC0r/oGWVMJrSNOMYSDZImUgslf4w544SElzH7
wWuNDq4+n9AfN0Wv6TYpEFfE1QQJ2FV5t6zBw7O1JXvdQpETp75DLJo3DIGJ1822
0USMAPspp1mnQpnr10SPX0ENF/aomEDRBO+bawVUCXE5uge05JI=
-----END CERTIFICATE REQUEST-----",
        uuid: SecureRandom.hex(10),
        csr_type: 'classic',
        requestor_id: Person.first.id,
        owner_dn_id: Person.first.distinguished_names.first.id,
        organization_id: Organization.first.id
    }
  end

  def test_valid_record
    valid_cert_req = CertificateRequest.new(valid_params)
    assert valid_cert_req.valid?, "Can't create with valid params: #{valid_cert_req.errors.messages}"
  end

  def test_without_compulsory_field
    compulsory_fields = [:status, :body, :uuid, :csr_type, :requestor_id, :owner_dn_id, :organization_id]
    compulsory_fields.each do |cf|
      invalid_params = valid_params.clone
      invalid_params.delete cf
      invalid_csr = CertificateRequest.new(invalid_params)
      refute invalid_csr.valid?, "Can't be valid without #{cf}"
      assert invalid_csr.errors[cf], "#{cf} can't be blank"
    end
  end

  def test_with_invalid_status
    invalid_status = 'lala'
    invalid_params = valid_params.clone
    invalid_params[:status] = invalid_status
    invalid_csr = CertificateRequest.new(invalid_params)
    refute invalid_csr.valid?, "Can't be valid with such a status."
    assert invalid_csr.errors[:status], "Invalid status"
  end

  def test_with_invalid_csr_type
    invalid_csr_type = 'lala'
    invalid_params = valid_params.clone
    invalid_params[:csr_type] = invalid_csr_type
    invalid_csr = CertificateRequest.new(invalid_params)
    refute invalid_csr.valid?, "Can't be valid with such a csr type."
    assert invalid_csr.errors[:status], "Invalid csr type."
  end

  def test_uniqueness_of_uuid
    invalid_params = valid_params.clone
    invalid_params[:uuid] = CertificateRequest.first.uuid
    invalid_csr = CertificateRequest.new(invalid_params)
    refute invalid_csr.valid?, "Can't be valid with such a uuid."
    assert invalid_csr.errors[:status], "UUID must be unique"
  end
end
