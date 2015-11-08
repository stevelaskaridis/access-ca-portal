require 'test_helper'

class CertificateTest < ActiveSupport::TestCase
  # def setup
  #   create_ca
  # end

  def valid_params
    {
        body: "-----BEGIN CERTIFICATE-----\nMIIFHjCCBAagAwIBAgIRAO90bvKn1tI07kbutKNBwsEwDQYJKoZIhvcNAQENBQAw\nIzEhMB8GA1UEAwwYaHR0cDovL2R1bW15LmV4YW1wbGUuY29tMB4XDTE1MTEwODE0\nMDAwMFoXDTE2MTEwODE0MDAwMFowTTELMAkGA1UEBhMCR1IxEzARBgNVBAoTCkhl\nbGxhc0dyaWQxEDAOBgNVBAsTB2F1dGguZ3IxFzAVBgNVBAMTDkpvaG4gQXBwbGVz\nZWVkMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAtvSSIq4T2ndJ6nFA\n84eN1VTqUut1s42CHc1NxJZiM1rwrkJESEt4pCS2Wc1sDbKUYEGRvpvgkcGpl1zE\nMNNsL9rOuN6glF8LrzAgcLuXZMCv5Oov1rqBU/pvnsMClYP5Qni6LgxwBm5y+31L\nocNTxhoXsRLpDa0tITv9O3dPeTEt4kIn6oRSR9vIcJ5dX+QrtEBNPCb7+BRZXz3p\nhLDYeqEt7ziHUzWyibnvWVrTN5gtcjso1yph2YvhLivvrxSu3qCFgzkZySe8DJs8\nK7koxGeJlG32a3//RCE3mRr/yvdMPJdWwobvaAWUtQ8zpXdBIasuq2okOpAp2If8\n2VphYwIDAQABo4ICITCCAh0wHQYDVR0OBBYEFA8binpTQ6lYcDwbZ+QAUOjl7Tat\nMBYGA1UdEQQPMA2GC2V4YW1wbGUuY29tMAsGA1UdDwQEAwIE8DAdBgNVHSUEFjAU\nBggrBgEFBQcDAgYIKwYBBQUHAwQwggFIBgNVHR8EggE/MIIBOzA9oDugOYY3aHR0\ncDovL2NybC5ncmlkLmF1dGguZ3IvaGVsbGFzZ3JpZC1jYS0yMDA2LzgyYjM2ZmNh\nLmNybDA9oDugOYY3aHR0cDovL2NybC5ncmlkLmF1dGguZ3IvaGVsbGFzZ3JpZC1j\nYS0yMDA2LzgyYjM2ZmNhLmNybDA9oDugOYY3aHR0cDovL2NybC5ncmlkLmF1dGgu\nZ3IvaGVsbGFzZ3JpZC1jYS0yMDA2LzgyYjM2ZmNhLmNybDA9oDugOYY3aHR0cDov\nL2NybC5ncmlkLmF1dGguZ3IvaGVsbGFzZ3JpZC1jYS0yMDA2LzgyYjM2ZmNhLmNy\nbDA9oDugOYY3aHR0cDovL2NybC5ncmlkLmF1dGguZ3IvaGVsbGFzZ3JpZC1jYS0y\nMDA2LzgyYjM2ZmNhLmNybDAJBgNVHSAEAjAAMAkGA1UdEwQCMAAwHwYDVR0jBBgw\nFoAUVD3mH5FkGgDi+q+plVbwEXTSagswNQYIKwYBBQUHAQEEKTAnMCUGCCsGAQUF\nBzABhhlvY3NwX2VuZHBvaW50LmV4YW1wbGUuY29tMA0GCSqGSIb3DQEBDQUAA4IB\nAQAmo14kUMZDWF03zacZq/ceLuUpIpOb5eET7Iyafuf3Xpo/etxqCbI7+chR7PLX\nn6fW/jWNf4OhDd9Y0xfcLBzr5YdJ3fL3IjOigKwDSctyFoPY0QaCi7Pss8QaYFGA\nR0XdV37QrdiUM2Nw3tj6eDGO7BgdY0BfdcLjvMK45ZLIbHfELY8rM1p++TuSDz1w\nXYPyLht1oIRYL6IZHQJsuv57HEx6vVY2ciEAu+oDBAYV2RB/nhXZpNOdCcqUFPs+\n83kN3crTbCE5jib4AnGQ4HRcpqz1Yx9bX1ffySkIiokcL2vsTDag7jPc3jDSRdEP\nlGXsIdEJaK9TbvzjGW6RF5O/\n-----END CERTIFICATE-----\n",
        status: "valid",
        certificate_request_uuid: CertificateRequest.first.uuid,
        distinguished_name_id: DistinguishedName.first.id
    }
  end

  def test_valid_record
    valid_cert = Certificate.new(valid_params)
    assert valid_cert.valid?, "Can't create with valid params: #{valid_cert.errors.messages}"
  end

  def test_invalid_body
    invalid_bodies = ['lala', '', '123']
    invalid_params = valid_params.clone
    invalid_bodies.each do |invalid_body|
      invalid_params['body'] = invalid_body
      invalid_cert = Certificate.new(invalid_params)
      refute invalid_cert.valid?, "Can't be valid with such a body, #{invalid_body}"
    end
  end

  def test_without_compulsory_field
    compulsory_fields = [:body, :status, :status, :certificate_request_uuid, :distinguished_name_id]
    compulsory_fields.each do |cf|
      invalid_params = valid_params.clone
      invalid_params.delete cf
      invalid_cert = Certificate.new(invalid_params)
      refute invalid_cert.valid?, "Can't be valid without #{cf}"
      assert invalid_cert.errors[cf], "#{cf} can't be blank"
    end
  end

  def test_with_invalid_status
    invalid_status = 'lala'
    invalid_params = valid_params.clone
    invalid_params[:status] = invalid_status
    invalid_cert = Certificate.new(invalid_params)
    refute invalid_cert.valid?, "Can't be valid with such a status (#{invalid_status})"
    assert invalid_cert.errors[:status], "Invalid status"
  end

  def test_person_with_valid_certificate
    Certificate.new(valid_params).save!
    second_cert_params = valid_params.clone
    second_cert_params[:certificate_request_uuid] = SecureRandom.hex(10)
    invalid_cert = Certificate.new(second_cert_params)
    refute invalid_cert.valid?, "Already have another valid cert."
  end

  private
    def create_ca
      @dummy_ca = CertificateAuthority::Certificate.new
      @dummy_ca.subject.common_name = "http://dummy.example.com"
      @dummy_ca.serial_number.number=1
      @dummy_ca.key_material.generate_key
      @dummy_ca.signing_entity = true
      sign_profile = {"extensions" => {"keyUsage" => {"usage" => ["critical", "keyCertSign"] }} }
      @dummy_ca.sign!(sign_profile)
      @dummy_ca
    end
end
