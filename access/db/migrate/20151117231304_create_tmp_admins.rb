class CreateTmpAdmins < ActiveRecord::Migration
  # Temporary model until RA, CA roles
  def change
    create_table :tmp_admins do |t|
      t.belongs_to :person
      t.timestamps null: false
    end
  end
end
