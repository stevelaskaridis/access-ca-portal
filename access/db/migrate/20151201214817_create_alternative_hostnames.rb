class CreateAlternativeHostnames < ActiveRecord::Migration
  def change
    create_table :alternative_hostnames do |t|
      t.string :address
      t.belongs_to :host, null: false, index: true
      t.timestamps null: false
    end
  end
end
