class CreateDistinguishedNames < ActiveRecord::Migration
  def change
    create_table :distinguished_names do |t|
      t.string :subject_dn
      t.integer :owner_id
      t.integer :owner_type
      t.timestamps null: false
    end
  end
end
