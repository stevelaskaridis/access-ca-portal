class CreatePersonEditableFields < ActiveRecord::Migration
  def change
    create_table :person_editable_fields do |t|
      fields = (Person.column_names - %w(id created_at updated_at)).map {|field| (field+'_'+'editable').to_sym}
      fields.each do |field|
        t.boolean(field)
      end
      t.belongs_to :person, index: true, foreign_key: :person_id
      t.timestamps null: false
    end
  end
end
