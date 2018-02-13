module API
  module V1
    class SchemaReference < ::JSONSchemaVersionReference
      include SchemaReferenceRelationships
    end
  end
end
