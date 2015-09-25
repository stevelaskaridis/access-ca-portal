class Person < ActiveRecord::Base
  belongs_to :scientific_field
  belongs_to :position

  validates :first_name_latin, presence: true
  validates :last_name_latin, presence: true
  validates :email, presence: true, uniqueness: true, email: true
  validates :scientific_field, presence: true
  validates :position, presence: true


  translates :first_name, :last_name, :position, :department
end
