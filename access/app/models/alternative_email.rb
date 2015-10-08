class AlternativeEmail < ActiveRecord::Base
  belongs_to :person, foreign_key: 'person_id'

  validates :email, presence: true, uniqueness: { case_sensitive: false }, email:true,
      alternative_email_email: true
end
