require 'test_helper'

class OrganizationTest < ActiveSupport::TestCase
  def valid_params
    {
        name: 'Org_name',
        description: 'org_description',
        domain: 'org.org'
    }
  end

  def test_valid_record
    normal_org = Organization.new(valid_params)
    assert normal_org.valid?, "Can't create with valid params: #{normal_org.errors.messages}"
  end

  def test_org_without_compulsory_field
    compulsory_fields = [:name, :domain]
    compulsory_fields.each do |f|
      invalid_params = valid_params.clone
      invalid_params.delete f
      invalid_org = Organization.new(invalid_params)
      refute invalid_org.valid?, "Can't be valid without #{f}"
    end
  end

  def test_case_insensitivity_of_domain
    invalid_params = valid_params.clone
    invalid_params[:domain] = Organization.first.domain.upcase
    invalid_org = Organization.new(invalid_params)
    refute invalid_org.valid?, "Case insensitivity does not work."
  end
end
