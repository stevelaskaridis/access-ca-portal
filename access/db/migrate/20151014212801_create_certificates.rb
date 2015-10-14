class CreateCertificates < ActiveRecord::Migration
  def change
    create_table :certificates do |t|
      t.text :body
      t.string :status
      t.integer :certificate_request_uuid
      t.belongs_to :distinguished_name
      t.timestamps null: false
    end
  end
end
