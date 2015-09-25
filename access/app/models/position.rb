class Position < ActiveRecord::Base
  validates :description, presence: true
end
