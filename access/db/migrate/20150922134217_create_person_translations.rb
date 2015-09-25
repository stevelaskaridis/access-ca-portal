class CreatePersonTranslations < ActiveRecord::Migration
  def up
    Person.create_translation_table!({
                                         first_name: :string,
                                         last_name: :string,
                                         department: :string
                                     },
    {
        migrate_data: true
                                     })
  end

  def down
    Person.drop_translation_table! migrate_data: true
  end
end
