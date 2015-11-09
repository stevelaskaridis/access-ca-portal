require 'test_helper'

class CertificateRequestTest < ActiveSupport::TestCase
  def valid_params
    {
        status: 'pending',
        comments: '',
        body: "-----BEGIN CERTIFICATE REQUEST-----\nMIIC6zCCAdMCAQAwgaUxCzAJBgNVBAYTAkdSMRUwEwYDVQQIEwxUaGVzc2Fsb25p\na2kxFTATBgNVBAcTDFRoZXNzYWxvbmlraTETMBEGA1UEChMKSGVsbGFzR3JpZDEQ\nMA4GA1UECxMHYXV0aC5ncjEXMBUGA1UEAxMOSm9obiBBcHBsZXNlZWQxKDAmBgkq\nhkiG9w0BCQEWGWpvaG5hcHBsZXNlZWRAZXhhbXBsZS5jb20wggEiMA0GCSqGSIb3\nDQEBAQUAA4IBDwAwggEKAoIBAQDx9w5KuNq00YWLqoOSttlujq5U8/IsSq9J0KJK\nAraJt8tf+bDGon1rR03b8p1VWV8MRxSZ5ruMvD6aXj7/kMt32M0T5wkMoALk8o6y\nOQuhAYlzi8IUjy2tL3SrL0VknBzb/IEsTbS2RtlhBUFYipN6JXKBw4kSMz58H+2L\nZfrqIMqeFpvuOh+WH8OXAkrQiR62q0e3c9jgDdjSH6ah6KXVZZd60Ox46mpwyzhc\nFkKPyX2aRCUxY0Pgk2m/nWixecqs4w2x8cNYiOIuhfu2q8YrVcmcSqI+gpfIr2Yr\nuCAYWDV0j0WKbWfMnFnTVNPmZOfBy4HyZqAUrABeR9q5vmnPAgMBAAGgADANBgkq\nhkiG9w0BAQsFAAOCAQEAYkGRNs0jt7g11vT2wRlgMTtlaK5XT20+A7nhRjSabnEo\n6ddhjs/4u0yqo9TWR1uZQMZVrDltNtvi6Li6kIIQJt1W7pwxSPzb4wYVWJoeDiEo\nhg9jhK6I+KT4vsC3JH5oqMv3NguCeR0BjxNJFnvYhuIpHyeDR5I224fGrAzVW+1V\nt3e8GaRSZsUIHK5lcc1URL01qu78Z2zoxTdTTdjMfMoIOxY4ENmgPXeb3B8c4JI6\nS/TQSYo7JOtswTlFZH0d8wDaEnmgGz5yTkqUHlortkZeBPh11mbeMYITrYJlR8O0\nwwQ9db9TkgqkP7SAH0Po5WFUU7Rdlao35e4qDRSiQQ==\n-----END CERTIFICATE REQUEST-----\n",
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
