class CreateJSONSchemaVersions < ActiveRecord::Migration[5.1]
  def change
    create_table :json_schema_versions, id: :uuid do |t|
      t.references :json_schema, type: :uuid, foreign_key: {on_delete: :cascade}
      t.integer :version_number, null: false
      t.string :schema_ref, null: false
      t.json :schema, null: false, default: {}
      t.json :example, null: false, default: {}

      t.index [:json_schema_id, :version_number], unique: true

      t.timestamps
    end
  end
end
