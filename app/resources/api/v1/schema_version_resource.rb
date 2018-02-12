module API
  module V1
    class SchemaVersionResource < BaseResource
      model_name 'API::V1::SchemaVersion'
      immutable
      has_one :current_schema

      attributes :version_number,
                 :schema_ref,
                 :schema,
                 :example,
                 :created_at,
                 :updated_at
    end
  end
end
