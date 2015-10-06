class Organization < ActiveRecord::Base
  has_many :people

  validates :domain, uniqueness: { case_sensitive: true }
  validates :name, presence: true

  translates :name, :description
end
