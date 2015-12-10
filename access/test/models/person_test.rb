require 'test_helper'

class PersonTest < ActiveSupport::TestCase

  def valid_params
    {
      first_name: 'Steve',
      last_name: 'Jobs',
      first_name_latin: 'Steve',
      last_name_latin: 'Jobs',
      email: "jobs@#{Organization.first.domain}",
      department: 'Technology',
      scientific_field: ScientificField.first,
      position: Position.first,
      organization: Organization.first,
      phone_number: '+306932123123'
    }
  end

  def test_valid_record
    normal_person = Person.new(valid_params)
    assert normal_person.valid?, "Can't create with valid params: #{normal_person.errors.messages}"
  end

  def test_person_without_compulsory_field
    compulsory_fields = [:email, :first_name_latin, :last_name_latin, :position, :scientific_field, :phone_number,
    :organization]
    compulsory_fields.each do |cf|
      invalid_params = valid_params.clone
      invalid_params.delete cf
      invalid_person = Person.new(invalid_params)
      refute invalid_person.valid?, "Can't be valid without #{cf}"
      assert invalid_person.errors[cf], "#{cf} can't be blank"
    end
  end

  def test_person_with_invalid_email
    invalid_emails = ['foo', '@bar', 'foo@bar']
    invalid_emails << 'foo@somenonorgdomain.com' if APP_CONFIG['registration']['accept_only_institutional_mails'] == 'true'
    invalid_emails.each do |ie|
      invalid_params = valid_params.clone
      invalid_params[:email] = ie
      invalid_person = Person.new(invalid_params)
      refute invalid_person.valid?, "Can't be valid with such an e-mail address: #{ie}"
      assert invalid_person.errors[:email], "Email is not an e-mail"
    end
  end

  def test_person_with_existent_email
    existent_emails = [Person.first.email, AlternativeEmail.first.email]
    existent_emails.each do |ee|
      invalid_params = valid_params.clone
      invalid_params[:email] = ee
      invalid_person = Person.new(invalid_params)
      refute invalid_person.valid?, "E-mail #{ee} already exists in the db."
      assert invalid_person.errors[:email], "Email already exists"
    end
  end

  def test_person_with_non_latin_name
    non_latin_names = ['43', 'some_latin_name32', 'Γιώργος']
    non_latin_names.each do |nln|
      [:first_name_latin, :last_name_latin].each do |name|
        invalid_params = valid_params.clone
        invalid_params[name] = nln
        invalid_person = Person.new(invalid_params)
        refute invalid_person.valid?, "Name should be in latin. (#{name} is not)"
        # assert email.errors[name], ""
      end
    end
  end

  def test_person_with_wrong_capitalization_in_name
    wrong_capitalized_names = ['name', 'NAME', 'NaMe']
    wrong_capitalized_names.each do |wn|
      [:first_name_latin, :last_name_latin].each do |name|
        invalid_params = valid_params.clone
        invalid_params[name] = wn
        invalid_person = Person.new(invalid_params)
        refute invalid_person.valid?, "Name should be in the form of first letter capital only. (#{name} is not)"
      end
    end
  end

  def test_person_with_invalid_phone
    wrong_phone_numbers = ['123', 'asdv', '6123312412']
    wrong_phone_numbers.each do |p|
      invalid_params = valid_params.clone
      invalid_params[:phone_number] = p
      invalid_person = Person.new(invalid_params)
      refute invalid_person.valid?, "Phone #{p} should be invalid."
    end
  end
end
