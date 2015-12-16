require 'exceptions/invalid_action'
require 'json'

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
  validates :body, presence: true
  validates :body, csr: true,
            unless: Proc.new {|obj| obj.body.nil?}
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

  def export_xml
    construct_request_hash.to_xml
  end

  def export_json
    construct_request_hash.to_json
  end

  def extract_alternative_names(show_order=false)
    dn = ""
    if self.csr_type == 'classic'
      dn = CertificateAuthority::SigningRequest.from_x509_csr(self.body).distinguished_name.x509_name.to_s
    elsif self.csr_type == 'spkac'
      dn = self.body.split("/SPKAC=")[0]
    end
    if (/subjectAltName/ =~ self.body)
      if show_order
        alt_names = dn.split('/subjectAltName=')[1].split(',')
      else
        alt_names = dn.split('/subjectAltName=')[1].split(Regexp.union([',', '='])).delete_if {|val| val=~ Regexp.union([/email\.\d+/, /DNS\.\d+/])}
      end

    else
      alt_names = []
    end
    alt_names
  end

  private
  def construct_request_hash
    request_hash = {}
    request_hash[:body] = self.body
    request_hash[:csr_type] = self.csr_type

    request_hash[:altnames] = extract_alternative_names(show_order: true)
    request_hash[:uniqueid] = self.uuid

    request_hash
  end
end
