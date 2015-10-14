class CreateCertificateRequests < ActiveRecord::Migration
  def change
    create_table :certificate_requests do |t|
      t.string :status
      t.text :comments
      t.text :body
      t.string :uuid
      t.string :csr_type
      t.integer :requestor_id
      t.integer :owner_dn_id
      t.belongs_to :organization, foreign_key: :organization_id

      t.timestamps null: false
    end
  end
end
