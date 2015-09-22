class Person < ActiveRecord::Base
  validates :first_name_latin, presence: true
  validates :last_name_latin, presence: true
  validates :email, presence: true, uniqueness: true, email: true

  translates :first_name, :last_name, :position, :department
end
