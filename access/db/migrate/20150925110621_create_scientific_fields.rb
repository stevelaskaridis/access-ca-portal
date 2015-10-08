class CreateScientificFields < ActiveRecord::Migration
  def change
    create_table :scientific_fields do |t|
      t.string :description
      t.timestamps null: false
    end
  end
end
