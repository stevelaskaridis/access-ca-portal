class CertificateRequest < ActiveRecord::Base
  # Associations
  belongs_to :requestor,
             class_name: 'Person',
             foreign_key: 'requestor_id'

  belongs_to :owner_dn,
             class_name: 'DistinguishedName',
             foreign_key: 'owner_dn_id'

  belongs_to :organization

  # Validations
  validates :status, presence: true, allow_nil: false
  validates_inclusion_of :status, in: %w(pending rejected signed approved)
  validates :body, presence: true, csr: true
  validates :uuid, presence: true, uniqueness: true
  validates :csr_type, presence: true, allow_nil: false
  validates_inclusion_of :csr_type, in: %w(classic spkac classic_ie vista_ie)
  validates :requestor_id, presence: true
  validates :owner_dn_id, presence: true, uniqueness: true
  validates :organization, presence: true

end
