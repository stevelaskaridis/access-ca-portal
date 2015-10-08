class AlternativeEmail < ActiveRecord::Base
  belongs_to :person, foreign_key: 'person_id'

  before_create :confirm_token

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
