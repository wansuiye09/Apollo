module API
  module V1
    class SchemaURIReader < ::SchemaURIReader
      private
      def model_map
        @model_map ||= {
          'schema'         => Schema,
          'schema-version' => SchemaVersion
        }
      end
    end
  end
end
