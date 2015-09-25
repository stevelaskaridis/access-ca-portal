class Position < ActiveRecord::Base
  validates :description, presence: true

  translates :description
end
