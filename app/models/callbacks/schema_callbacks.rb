module SchemaCallbacks
  extend ActiveSupport::Concern

  included do
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
