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
      t.belongs_to :scientific_field, index: true

      t.timestamps null: false
    end
  end
end
