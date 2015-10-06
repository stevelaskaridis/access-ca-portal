class Person < ActiveRecord::Base
  # Associations
  belongs_to :scientific_field
  belongs_to :position
  belongs_to :organization
  has_many :alternative_emails, dependent: :delete_all

  # Validations
  validates :first_name_latin, presence: true
  validates_format_of :first_name_latin, :with => /\A[A-Z][a-z]*\Z/
  validates :last_name_latin, presence: true
  validates_format_of :last_name_latin, :with => /\A[A-Z][a-z]*\Z/
  validates :email, presence: true, uniqueness: true, email: true, email_alternative_email: true
  validates :scientific_field, presence: true
  validates :position, presence: true
  validates :organization, presence: true
  validates :phone_number, presence: true, phone: true


  translates :first_name, :last_name, :department

  def get_alternative_emails
    self.alternative_emails.map { |obj| obj.email }.join("\n")
  end
end
