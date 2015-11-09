class DistinguishedName < ActiveRecord::Base
  belongs_to :owner, polymorphic: true

  validates :subject_dn, presence: true, dn: true
  validates_inclusion_of :owner_type, in: %w(Person Host)
end
