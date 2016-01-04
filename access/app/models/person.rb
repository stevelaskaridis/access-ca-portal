class Person < ActiveRecord::Base
  # Associations
  belongs_to :scientific_field
  belongs_to :position
  belongs_to :organization
  has_many :alternative_emails, dependent: :delete_all
  has_one :person_editable_field
  has_many :distinguished_names, as: :owner

  before_create :confirm_token

  # Validations
  validates :first_name_latin, presence: true, length: { maximum: 254 }
  validates_format_of :first_name_latin, :with => /\A[A-Z][a-z]*\Z/
  validates :last_name_latin, presence: true, length: { maximum: 254 }
  validates_format_of :last_name_latin, :with => /\A[A-Z][a-z]*\Z/
  validates :email, presence: true, uniqueness: true, email: true, email_alternative_email: true, length: { maximum: 254 }
  validates :email, institutional_email: true if APP_CONFIG['registration']['accept_only_institutional_mails'] == 'true'

  validates :scientific_field, presence: true
  validates :position, presence: true
  validates :organization, presence: true
  validates :phone_number, presence: true, phone: true
  validates :first_name, length: { maximum: 254 }
  validates :last_name, length: { maximum: 254 }
  validates :department, length: { maximum: 254 }


  translates :first_name, :last_name, :department, versioning: :paper_trail

  has_paper_trail


  after_create do
    pef = PersonEditableField.new(person_id: self.id)
    pef.save
    self.person_editable_field = pef
  end

  def get_alternative_emails
    self.alternative_emails.map { |obj| obj.email }.join("\n")
  end

  def self.find_by_alt_verification_token(token)
    alt_mail = AlternativeEmail.find_by_verification_token token
    return alt_mail.person, alt_mail
  end

  def activate_email
    self.verified = true
    self.verification_token = nil
    save!
  end

  def confirm_token
    if self.verification_token.blank?
      self.verification_token = SecureRandom.urlsafe_base64.to_s
    end
  end

  def certificate_requests
    person_csrs = []
    person_csrs << self.distinguished_names.map { |dn| dn.certificate_requests.to_a }
    person_csrs
  end
end
