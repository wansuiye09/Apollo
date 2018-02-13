class SchemaURIReader < JSON::Schema::Reader
  attr_reader :uri,
              :schema,
              :captured_records

  delegate :host,
           :scheme,
           to: :uri

  def read(location)
    @uri    = JSON::Util::URI.parse(location)
    @schema = case scheme
              when 'file' then read_schema_from_file
              when *custom_schemes then custom_schema
              when *allowed_remote_schemes
                super if allowed_remote_domains.include?(host)
              else
                default_raise
              end

    default_raise unless schema.present?
    JSON::Schema.new(schema, uri)
  end

  private

  def allowed_remote_schemes
    @allowed_remote_schemes ||= ['http']
  end

  def allowed_remote_domains
    @allowed_remote_domains ||= ['json-schema.org']
  end

  def custom_schemes
    @custom_schemes ||= model_map.keys
  end

  def model_map
    @model_map ||= {
      'schema'         => JSONSchema,
      'schema-version' => JSONSchemaVersion
    }
  end

  def default_raise
    raise JSON::Schema::ReadFailed.new(uri.to_s, :uri)
  end

  def read_schema_from_file
    file = Pathname.new(@uri.path).expand_path

    if file.to_s.starts_with?("#{ENV['GEM_HOME']}/gems/json-schema")
      @uri = JSON::Util::URI.file_uri(uri)
      return JSON::Validator.parse(read_file(file))
    end

    default_raise
  end

  def custom_schema
    record = model_map[scheme].find(host)
    capture_record(scheme.underscore, record)
    record.schema
  rescue ActiveRecord::RecordNotFound
    default_raise
  end

  def capture_record(group, record)
    @captured_records        ||= {}
    @captured_records[group] ||= []
    @captured_records[group] << record
    @captured_records[group].uniq!
  end
end
