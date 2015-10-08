class Organization < ActiveRecord::Base
  has_many :people

  validates :domain, uniqueness: { case_sensitive: false }, presence: true
  validates :name, presence: true

  translates :name, :description
end
