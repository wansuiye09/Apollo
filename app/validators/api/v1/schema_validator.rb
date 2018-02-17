module API
  module V1
    class SchemaValidator < ActiveModel::Validator
      SCHEMAS = JSON::Schema.
                core_schemas.
                keys.
                deep_dup.
                map(&:freeze).
                freeze

      attr_reader :record
      delegate :errors,
               :schema_ref,
               :schema,
               :example,
               to: :record

      def validate(record)
        @record = record
        validate_schema_ref
        validate_schema
        validate_example_with_schema
        pass_captured_records
      end

      private

      def validate_schema_ref
        errors.add(:schema_ref, :inclusion) unless SCHEMAS.include?(schema_ref)
      end

      def validate_and_example
        return if errors[:schema_ref].present?
        return errors.add(:schema, :invalid_schema) if schema['id'].present?

        JSON::Schema.validate!(
          JSON::Schema.core_schemas[schema_ref],
          schema,
          validation_options
        )
      rescue JSON::Schema::InvalidSchema, JSON::Schema::ReadFailed, JSON::Schema::ReadRefused
        errors.add(:schema, :invalid_schema)
      rescue JSON::Schema::ValidationFailed
        errors.add(:example, :invalid_example)
      end

      def validation_options
        @schema_reader ||= SchemaURIReader.new
        {
          reader: @schema_reader
        }
      end

      def pass_captured_records
        return unless record.respond_to?(:captured_records=)
        record.captured_records = @schema_reader.captured_records
      end
    end
  end
end
