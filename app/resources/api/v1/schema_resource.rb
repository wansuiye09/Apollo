module API
  module V1
    class SchemaResource < BaseResource
      model_name 'API::V1::Schema'
      has_many :versions

      attributes :schema_ref,
                 :schema,
                 :example,
                 :created_at,
                 :updated_at
    end
  end
end
