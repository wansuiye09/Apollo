module API
  module V1
    class SchemaVersion < ::JSONSchemaVersion
      include SchemaVersionRelationships
      include SchemaVersionCallbacks
    end
  end
end
