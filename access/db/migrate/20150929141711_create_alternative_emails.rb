class CreateAlternativeEmails < ActiveRecord::Migration
  def change
    create_table :alternative_emails do |t|
      t.belongs_to :person, null: false, index:true
      t.string :email, null: false
      t.boolean :verified, default: false, null: false
      t.string :verification_token
      t.timestamps null: false
    end
  end
end
