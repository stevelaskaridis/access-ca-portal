class TmpAdmin < ActiveRecord::Base
  # Temporary model until RA, CA roles
  belongs_to :people

  def self.is_admin?(person)
    return true if TmpAdmin.find_by_person_id person.id
    false
  end
end
