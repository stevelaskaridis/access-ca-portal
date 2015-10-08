require 'test_helper'

class PositionTest < ActiveSupport::TestCase
  def valid_params
    {
        description: 'position description',
    }
  end

  def test_valid_position_record
    valid_rec = Position.new(valid_params)
    assert valid_rec.valid? "Can't create with valid params: #{valid_rec.errors.messages}"
  end

  def test_without_compulsory_field
    compulsory_fields = [:description]
    compulsory_fields.each do |cf|
      invalid_params = valid_params.clone
      invalid_params.delete cf
      invalid_rec = Position.new(invalid_params)
      refute invalid_rec.valid?, "Can't be valid without #{cf}"
      assert invalid_rec.errors[cf], "#{cf} can't be blank."
    end
  end

end
