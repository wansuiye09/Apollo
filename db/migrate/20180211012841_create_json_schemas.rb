class CreateJSONSchemas < ActiveRecord::Migration[5.1]
  def change
    create_table :json_schemas, id: :uuid do |t|
      t.string :schema_ref, null: false
      t.json :schema, null: false, default: {}
      t.json :example, null: false, default: {}

      t.timestamps
    end
  end
end
