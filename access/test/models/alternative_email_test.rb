require 'test_helper'

class AlternativeEmailTest < ActiveSupport::TestCase
  def valid_params
    {
        person: Person.first,
        email: 'somemail@example.com',
        verified: true
    }
  end

  def test_valid_record
    valid_rec = AlternativeEmail.new(valid_params)
    assert valid_rec.valid?, "Can't create with valid params: #{valid_rec.errors.messages}"
  end

  def test_alternative_email_without_compulsory_field
    compulsory_fields = [:email]
    compulsory_fields.each do |cf|
      invalid_params = valid_params.clone
      invalid_params.delete cf
      invalid_person = AlternativeEmail.new(invalid_params)
      refute invalid_person.valid?, "Can't be valid without #{cf}"
      assert invalid_person.errors[cf], "#{cf} can't be blank"
    end
  end

  def test_alternative_email_with_invalid_email
    invalid_emails = ['foo', '@bar', 'foo@bar']
    invalid_emails.each do |ie|
      invalid_params = valid_params.clone
      invalid_params[:email] = ie
      invalid_person = AlternativeEmail.new(invalid_params)
      refute invalid_person.valid?, "Can't be valid with such an e-mail address: #{ie}"
      assert invalid_person.errors[:email], "Email is not an e-mail"
    end
  end
end
