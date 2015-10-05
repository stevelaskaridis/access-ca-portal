class Position < ActiveRecord::Base
  validates :description, presence: true, uniqueness: true

  translates :description
end
