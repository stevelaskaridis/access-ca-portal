class DistinguishedName < ActiveRecord::Base
  belongs_to :owner, polymorphic: true

  validates :subject_dn, presence: true, dn: true
  validates_inclusion_of :owner_type, in: %w(Person Host)
  has_many :certificate_requests, foreign_key: :owner_dn_id
  has_many :certificates
end
