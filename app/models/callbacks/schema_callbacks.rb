module SchemaCallbacks
  extend ActiveSupport::Concern

  included do
    after_commit :save_version
    after_commit :touch_versions, on: :update
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

  def touch_versions
    versions.each(&:touch)
  end
end
