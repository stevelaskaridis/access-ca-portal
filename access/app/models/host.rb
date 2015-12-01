class Host < ActiveRecord::Base
  # Associations
  belongs_to :person
  belongs_to :organization
  has_many :distinguished_names, as: :owner
  has_many :alternative_hostnames

  # Validations
  validates :person, presence: true
  validates :organization, presence: true
  validates :fqdn, presence: true, hostname: true

  # Versioning
  has_paper_trail
end
