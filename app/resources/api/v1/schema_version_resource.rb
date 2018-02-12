module API
  module V1
    class SchemaVersionResource < BaseResource
      model_name 'API::V1::SchemaVersion'
      immutable
      caching

      has_one  :primary_schema
      has_one  :current_version
      has_many :versions

      attributes :version_number,
                 :schema_ref,
                 :schema,
                 :example,
                 :created_at,
                 :updated_at
    end
  end
end
