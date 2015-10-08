class CreatePositionTranslations < ActiveRecord::Migration
  def up
    Position.create_translation_table!({
                                                  description: :string
                                              },
                                              {
                                                  migration_data: true
                                              })
  end

  def down
    Position.drop_translation_table! migrate_data: true
  end
end
