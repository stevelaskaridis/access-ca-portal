class Certificate < ActiveRecord::Base
  # Associations
  belongs_to :certificate_request_uuid,
             class_name: 'CertificateRequest',
             primary_key: 'uuid'

  belongs_to :owner_dn,
             class_name: 'DistinguishedName',
             foreign_key: 'owner'

  # Validations
  validates :body, presence: true
  validates :status, presence: true
  validates :certificate_request_uuid, presence: true
  validates :distinguished_name_id, presence: true
end
