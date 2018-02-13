module SchemaVersionRelationships
  extend ActiveSupport::Concern

  included do
    belongs_to :primary_schema,
               foreign_key: :json_schema_id,
               class_name: 'Schema'

    has_many :versions, through: :primary_schema
    has_one :current_version,
            through: :primary_schema

    has_many :outbound_references,
             foreign_key: :referencing_version_id,
             class_name: 'SchemaReference'
    has_many :inbound_references,
             foreign_key: :referenced_version_id,
             class_name: 'SchemaReference'

    has_many :referenced_versions,
             through: :outbound_references
    has_many :referencing_versions,
             through: :inbound_references
  end
end
