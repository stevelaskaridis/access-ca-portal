class AlternativeEmail < ActiveRecord::Base
  belongs_to :person, foreign_key: 'person_id'
  has_many :certificates, as: :alternative_name
  has_many :alternative_names, as: :alternative_ident

  before_create :confirm_token

  validates :person, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }, email:true,
      alternative_email_email: true

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
end
