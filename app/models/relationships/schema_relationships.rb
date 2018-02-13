module SchemaRelationships
  extend ActiveSupport::Concern

  included do
    has_many :versions,
             foreign_key: :json_schema_id,
             class_name: 'SchemaVersion'

    has_one :current_version,
            ->{ readonly.order(version_number: :desc).limit(1) },
            foreign_key: :json_schema_id,
            class_name: 'SchemaVersion'
  end
end
