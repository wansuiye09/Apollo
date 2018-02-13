module API
  module V1
    module SchemaVersionCallbacks
      extend ActiveSupport::Concern

      included do
        attr_accessor :captured_records
        validates_with SchemaValidator, on: :create
        after_validation :versionize_schema,
        if: ->(ver){ ver.captured_records.present? },
          on: :create
        end

        private

        def versionize_schema
          @temp_schema     = schema.to_json
          @temp_references = []

          process_captured_records
          self.schema = @temp_schema

          @temp_references.uniq.each do |ref|
            outbound_references.build(referenced_version: ref)
          end
        end

        def process_captured_records
          captured_primary_schemas.each do |id, sch|
            action = -> do
              @temp_references << sch.current_version
              temp_schema_sub(id, sch.current_version.id)
            end

            sch == primary_schema ? action.call : sch.with_lock{ action.call }
          end

          @temp_references += captured_versions
          @temp_schema = JSON.parse(@temp_schema)
        end

        def temp_schema_sub(sch_id, ver_id)
          @temp_schema.sub!(
            "schema://#{sch_id}",
            "schema-version://#{ver_id}"
          )
        end

        def captured_primary_schemas
          return {} unless captured_records['schema'].present?
          Hash[captured_records['schema'].map{|sch| [sch.id, sch] }]
        end

        def captured_versions
          return [] unless captured_records['schema_version'].present?
          captured_records['schema_version']
        end
      end
  end
end
