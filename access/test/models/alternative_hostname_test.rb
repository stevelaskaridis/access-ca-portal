require 'test_helper'

class AlternativeHostnameTest < ActiveSupport::TestCase
  def valid_params
    {
        host: Host.first,
        address: 'foo.com',
    }
  end

  def test_valid_record
    valid_rec = AlternativeHostname.new(valid_params)
    assert valid_rec.valid?, "Can't create with valid params: #{valid_rec.errors.messages}"
  end

  def test_alternative_hostname_without_compulsory_field
    compulsory_fields = [:host, :address]
    compulsory_fields.each do |cf|
      invalid_params = valid_params.clone
      invalid_params.delete cf
      invalid_host = AlternativeHostname.new(invalid_params)
      refute invalid_host.valid?, "Can't be valid without #{cf}"
      assert invalid_host.errors[cf], "#{cf} can't be blank"
    end
  end

  def test_alternative_hostname_with_invalid_hostname
    invalid_hostnames = %w(foo foo@bar.com 123^.com!)
    invalid_hostnames.each do |ih|
      invalid_params = valid_params.clone
      invalid_params[:address] = ih
      invalid_hostname = AlternativeHostname.new(invalid_params)
      refute invalid_hostname.valid?, "Can't be valid with such an hostname: #{ih}"
      assert invalid_hostname.errors[:address], "Hostname is not a hostname"
    end
  end
end
