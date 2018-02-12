module SchemaVersionRelationships
  extend ActiveSupport::Concern

  included do
    belongs_to :primary_schema,
               foreign_key: :json_schema_id,
               class_name: 'Schema'

    has_one :current_version,
            through: :primary_schema,
            source: :current_version

    has_many :versions, through: :primary_schema
  end
end
