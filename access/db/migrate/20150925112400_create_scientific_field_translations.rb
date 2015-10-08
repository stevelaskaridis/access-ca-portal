class CreateScientificFieldTranslations < ActiveRecord::Migration
  def up
    ScientificField.create_translation_table!({
                                                  description: :string
                                              },
    {
        migration_data: true
    })
  end

  def down
    ScientificField.drop_translation_table! migrate_data: true
  end
end
