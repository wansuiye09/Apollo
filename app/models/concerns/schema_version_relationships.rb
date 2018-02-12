module SchemaVersionRelationships
  extend ActiveSupport::Concern

  included do
    belongs_to :current_schema,
               foreign_key: :json_schema_id,
               class_name: 'Schema'
  end
end
