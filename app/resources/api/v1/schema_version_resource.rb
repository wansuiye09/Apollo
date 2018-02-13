module API
  module V1
    class SchemaVersionResource < BaseResource
      model_name 'API::V1::SchemaVersion'
      immutable
      caching

      has_one :primary_schema
      has_many :versions
      has_many :referenced_versions
      has_many :referencing_versions
      relationship :current_version,
                   to: :one,
                   foreign_key_on: :related

      attributes :version_number,
                 :schema_ref,
                 :schema,
                 :example,
                 :created_at,
                 :updated_at
    end
  end
end
