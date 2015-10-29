class DistinguishedName < ActiveRecord::Base
  belongs_to :owner, polymorphic: true

  validates :subject_dn, presence: true
end
