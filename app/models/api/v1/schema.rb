module API
  module V1
    class Schema < ::JSONSchema
      include SchemaRelationships
      include SchemaCallbacks

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

      before_validation :set_schema_ref

      # TODO: Move into a custom validator.
      validates :schema_ref, inclusion: SCHEMAS
      validate :validate_schema,
               :validate_example_with_schema

      private

      def set_schema_ref
        if schema_ref.present?
          schema['$schema'] = schema_ref
        elsif schema['$schema'].present?
          self.schema_ref = schema['$schema']
        else
          default = 'http://json-schema.org/draft-06/schema#'
          self.schema_ref = default
          schema['$schema'] = default
        end
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
    end
  end
end
