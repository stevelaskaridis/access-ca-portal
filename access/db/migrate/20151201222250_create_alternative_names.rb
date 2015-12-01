class CreateAlternativeNames < ActiveRecord::Migration
  def change
    create_table :alternative_names do |t|
      t.integer :alternative_ident_id, null: false
      t.string :alternative_ident_type, null: false
      t.timestamps null: false
    end
  end
end
