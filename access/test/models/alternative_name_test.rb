require 'test_helper'

class AlternativeNameTest < ActiveSupport::TestCase
  def valid_params(type)
    case type
      when 'Person'
        return {
            alternative_ident_id: Person.first.id,
            alternative_ident_type: type
        }
      when 'Host'
        return {
            alternative_ident_id: Host.first.id,
            alternative_ident_type: type
        }
    end
    {
        alternative_ident_id: Person.first.id,
        alternative_ident_type: 'Person'
    }
  end

  def test_valid_record
    types = %w(Person Host)
    types.each do |type|
      valid_rec = AlternativeName.new(valid_params(type))
      assert valid_rec.valid?, "Can't create with valid params: #{valid_rec.errors.messages}"
    end
  end

  def test_alternative_name_without_compulsory_field
    compulsory_fields = [:alternative_ident_id, :alternative_ident_type]
    compulsory_fields.each do |cf|
      types = %w(Person Host)
      types.each do |type|
        invalid_params = valid_params(type).clone
        invalid_params.delete cf
        invalid_person = AlternativeName.new(invalid_params)
        refute invalid_person.valid?, "Can't be valid without #{cf}"
        assert invalid_person.errors[cf], "#{cf} can't be blank"
      end
    end
  end
end
