require 'exceptions/invalid_action'

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
  validates :body, hostname_dn: true,
            if: Proc.new { |obj|
              if obj.owner_dn_id
                DistinguishedName.find(obj.owner_dn_id).owner_type == 'Host'
              else
                errors[:body] << "No dn provided to assess."
              end

                } # in case of error, this is difficult to debug
  validates :uuid, presence: true, uniqueness: true
  validates :csr_type, presence: true, allow_nil: false
  validates_inclusion_of :csr_type, in: %w(classic spkac classic_ie vista_ie)
  validates :requestor_id, presence: true
  validates :owner_dn_id, presence: true, uniqueness: true
  validates :organization_id, presence: true

  def self.approve_csr(csr_id)
    csr = CertificateRequest.find(csr_id)
    if csr.status == 'pending'
      csr.status = 'approved'
      csr.save!
    else
      raise InvalidActionError.new("#{I18n.t "exceptions.invalid_action.approve_csr"} #{csr.status}")
    end
  end

  def self.reject_csr(csr_id)
    csr = CertificateRequest.find(csr_id)
    if csr.status == 'pending'
      csr.status = 'rejected'
      csr.save!
    else
      raise InvalidActionError.new("#{I18n.t "exceptions.invalid_action.reject_csr"} #{csr.status}")
    end
  end
end
