class CreateOrganizationTranslations < ActiveRecord::Migration
  def up
    Organization.create_translation_table!({
                                           name: :string,
                                           description: :text,
                                       },
                                       {
                                           migration_data: true
                                       })
  end

  def down
    Organization.drop_translation_table! migrate_data: true
  end
end
