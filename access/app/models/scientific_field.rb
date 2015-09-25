class ScientificField < ActiveRecord::Base
  validates :description, presence: true
end
