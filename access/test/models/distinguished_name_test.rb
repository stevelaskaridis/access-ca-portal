require 'test_helper'

class DistinguishedNameTest < ActiveSupport::TestCase
  def valid_params
    {
        subject_dn: "/C=GR/O=HellasGrid/OU=auth.gr/CN=#{Person.first.first_name_latin} #{Person.first.last_name_latin}",
        owner_id: Person.first.id,
        owner_type: 'Person',
    }
  end

  def test_valid_record
    valid_dn = DistinguishedName.new(valid_params)
    assert valid_dn.valid?,  "Can't create with valid params: #{valid_dn.errors.messages}"
  end

  def test_without_compulsory_field
    compulsory_fields = [:subject_dn]
    compulsory_fields.each do |cf|
      invalid_params = valid_params.clone
      invalid_params.delete cf
      invalid_dn = DistinguishedName.new(invalid_params)
      refute invalid_dn.valid?, "Can't be valid without #{cf}"
      assert invalid_dn.errors[cf], "#{cf} can't be blank"
    end
  end

  def test_with_invalid_subject_dn
    invalid_dns = ["lala", "%{valid_params.subject_dn.downcase}",
                   "/C=GR/O=HellasGrid/OU=auth.gr/CN=Δημήτρης Παπαδόπουλος",]
    invalid_dns.each do |idn|
      invalid_params = valid_params.clone
      invalid_params[:subject_dn] = idn
      invalid_dn = DistinguishedName.new(invalid_params)
      refute invalid_dn.valid?, "Can't be valid with such an subject dn: #{idn}"
      assert invalid_dn.errors[:subject_dn], "subject_dn is not an valid DN."
    end
  end

end
