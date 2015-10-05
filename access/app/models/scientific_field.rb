class ScientificField < ActiveRecord::Base
  validates :description, presence: true, uniqueness: true

  translates :description
end
