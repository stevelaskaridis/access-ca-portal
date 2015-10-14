class CreateHosts < ActiveRecord::Migration
  def change
    create_table :hosts do |t|
      t.string :fqdn
      t.belongs_to :person, index: true, foreign_key: :person_id
      t.belongs_to :organization, index: true, foreign_key: :organization_id
      t.timestamps null: false
    end
  end
end
