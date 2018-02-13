class CreateJSONSchemaVersionReferences < ActiveRecord::Migration[5.1]
  def change
    create_table :json_schema_version_references, id: :uuid do |t|
      reference_options = {
        foreign_key: {
          to_table: :json_schema_versions
        },
        type: :uuid
      }

      t.references :referenced_version, **reference_options
      t.references :referencing_version, **reference_options
    end
  end
end
