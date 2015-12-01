class Certificate < ActiveRecord::Base
  include ActiveModel::Validations

  # Associations
  belongs_to :certificate_request,
             class_name: 'CertificateRequest',
             foreign_key: 'certificate_request_uuid'

  belongs_to :owner_dn,
             class_name: 'DistinguishedName',
             foreign_key: 'distinguished_name_id'

  belongs_to :alternative_name, polymorphic: true

  # Validations
  validates :body, presence: true, cert: true
  validates :status, presence: true
  validates_inclusion_of :status, in: %w(revoked not_accepted expired valid)
  validates :certificate_request_uuid, presence: true, uniqueness: true
  validates :distinguished_name_id, presence: true
  validates_with CertificateValidator
end
