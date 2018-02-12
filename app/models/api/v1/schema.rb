module API
  module V1
    class Schema < ::JSONSchema
      include SchemaRelationships

      SCHEMAS = JSON::Validator.
                validators.
                values.
                map(&:names).
                flatten.
                deep_dup.
                map(&:freeze).
                freeze

      validates :schema_ref, inclusion: SCHEMAS
      validate :validate_schema,
               :validate_example_with_schema

      private

      def validate_schema
        return if errors[:schema_ref].present?
        metaschema = JSON::Validator.validator_for_name(schema_ref).metaschema
        unless JSON::Validator.validate(metaschema, schema, validation_options)
          errors.add(:schema, :invalid_schema)
        end
      end

      def validate_example_with_schema
        return if errors[:schema].present?
        unless JSON::Validator.validate(schema, example, validation_options)
          errors.add(:example, :schema_mismatch)
        end
      end

      def validation_options
        {
          clear_cache: true
        }
      end
    end
  end
end
