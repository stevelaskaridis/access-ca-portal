class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :first_name
      t.string :last_name
      t.string :first_name_latin
      t.string :last_name_latin
      t.string :email
      t.string :position
      t.string :department

      t.timestamps null: false
    end
  end
end
