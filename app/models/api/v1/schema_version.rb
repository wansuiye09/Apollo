module API
  module V1
    class SchemaVersion < ::JSONSchemaVersion
      include SchemaVersionRelationships
    end
  end
end
