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

    after_commit :save_version
  end

  private

  def save_version
    with_lock do
      versions.create(
        schema_ref: schema_ref,
        schema: schema,
        example: example,
        version_number: versions.count + 1
      )
    end
  end
end
