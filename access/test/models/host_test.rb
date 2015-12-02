require 'test_helper'

class HostTest < ActiveSupport::TestCase
  def valid_params
    {
        fqdn: "#{Organization.first.domain}",
        person_id: Person.first.id,
        organization_id: Organization.first.id,
    }
  end

  def test_valid_record
    valid_rec = Host.new(valid_params)
    assert valid_rec.valid?, "Can't create with valid params #{valid_rec.fqdn}: #{valid_rec.errors.messages}"
  end

  def test_host_without_compulsory_field
    compulsory_fields = [:person_id, :organization_id, :fqdn]
    compulsory_fields.each do |cf|
      invalid_params = valid_params.clone
      invalid_params.delete cf
      invalid_host = Host.new(invalid_params)
      refute invalid_host.valid?, "Can't be valid without #{cf}"
      assert invalid_host.errors[cf], "#{cf} can't be blank"
    end
  end

  def test_invalid_fqdn
    org = Organization.find valid_params[:organization_id]
    invalid_fqdns = ["#{org}.example.com", 'foo.bar.com', 'bar@foo.com']
    invalid_fqdns.each do |ih|
      invalid_params = valid_params.clone
      invalid_params[:fqdn] = ih
      invalid_hostname = Host.new(invalid_params)
      refute invalid_hostname.valid?, "Can't be valid with such an hostname: #{ih}"
      assert invalid_hostname.errors[:fqdn], "Hostname is not a valid one"
    end
  end
end
