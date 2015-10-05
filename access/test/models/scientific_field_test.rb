require 'test_helper'

class ScientificFieldTest < ActiveSupport::TestCase
  def valid_params
    {
        description: 'Scientific field description',
    }
  end

  def test_valid_scientific_field_record
    valid_rec = ScientificField.new(valid_params)
    assert valid_rec.valid? "Can't create with valid params: #{valid_rec.errors.messages}"
  end

  def test_without_compulsory_field
    compulsory_fields = [:description]
    compulsory_fields.each do |cf|
      invalid_params = valid_params.clone
      invalid_params.delete cf
      invalid_rec = ScientificField.new(invalid_params)
      refute invalid_rec.valid?, "Can't be valid without #{cf}"
      assert invalid_rec.errors[cf], "#{cf} can't be blank."
    end
  end

end
