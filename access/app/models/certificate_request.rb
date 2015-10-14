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
  validates :status, presence: true
  validates :body, presence: true
  validates :uuid, presence: true, uniqueness: true
  validates :csr_type, presence: true
  validates :requestor_id, presence: true
  validates :owner_dn_id, presence: true
  validates :organization, presence: true

  # TODO: More validation concerning the type and csr_type

end
