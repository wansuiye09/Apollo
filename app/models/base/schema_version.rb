module Base
  class SchemaVersion < ::JSONSchemaVersion
    include SchemaVersionRelationships
  end
end
