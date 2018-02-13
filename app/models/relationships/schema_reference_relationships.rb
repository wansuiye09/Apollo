module SchemaReferenceRelationships
  extend ActiveSupport::Concern

  included do
    belongs_to :referenced_version,
               class_name: 'SchemaVersion'

    belongs_to :referencing_version,
               class_name: 'SchemaVersion'
  end
end
