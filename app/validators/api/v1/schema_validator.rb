module API
  module V1
    class SchemaValidator < ActiveModel::Validator
      SCHEMAS = JSON::Validator.
                validators.
                values.
                map(&:names).
                flatten.
                uniq.
                select{|ref| ref =~ /\Ahttp/ }.
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

      def validate_schema
        return if errors[:schema_ref].present?
        return errors.add(:schema, :invalid_schema) if schema['id'].present?

        metaschema = JSON::Validator.validator_for_name(schema_ref).metaschema
        unless JSON::Validator.validate(metaschema, schema, validation_options)
          errors.add(:schema, :invalid_schema)
        end
      rescue JSON::Schema::ReadFailed, JSON::Schema::ReadRefused
        errors.add(:schema, :invalid_schema)
      end

      def validate_example_with_schema
        return if errors[:schema].present?

        unless JSON::Validator.validate(schema, example, validation_options)
          errors.add(:example, :invalid_example)
        end
      rescue JSON::Schema::ReadFailed, JSON::Schema::ReadRefused
        errors.add(:example, :invalid_example)
      end

      def validation_options
        @schema_reader ||= SchemaURIReader.new
        {
          clear_cache: true,
          schema_reader: @schema_reader
        }
      end

      def pass_captured_records
        return unless record.respond_to?(:captured_records=)
        record.captured_records = @schema_reader.captured_records
      end
    end
  end
end
