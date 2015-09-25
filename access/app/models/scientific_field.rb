class ScientificField < ActiveRecord::Base
  validates :description, presence: true

  translates :description
end
