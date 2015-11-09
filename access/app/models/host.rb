class Host < ActiveRecord::Base
  # Associations
  belongs_to :person
  belongs_to :organization
  has_many :distinguished_names, as: :owner

  # Validations
  validates :person, presence: true
  validates :organization, presence: true

  # Versioning
  has_paper_trail
end
