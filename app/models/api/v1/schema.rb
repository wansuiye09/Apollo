module API
  module V1
    class Schema < ::JSONSchema
      SCHEMA_REF = 'http://json-schema.org/draft-06/schema#'.freeze

      include SchemaRelationships
      include SchemaCallbacks

      before_validation :set_schema_ref
      validates_with SchemaValidator

      private

      def set_schema_ref
        if schema_ref.present? then schema['$schema'] = schema_ref
        elsif schema['$schema'].present? then self.schema_ref = schema['$schema']
        else
          self.schema_ref   = SCHEMA_REF
          schema['$schema'] = SCHEMA_REF
        end
      end
    end
  end
end
