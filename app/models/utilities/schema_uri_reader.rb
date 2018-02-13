class SchemaURIReader < JSON::Schema::Reader
  attr_reader :captured_records

  def read(location)
    @uri = JSON::Util::URI.parse(location)
    @captured_records ||= {}

    case @uri.scheme
    when 'schema', 'schema-version'
      set_schema
    when 'file'
      read_file_to_schema
    when 'http', 'https'
      if allowed_domains.include?(@uri.host)
        return super
      else
        default_raise
      end
    else
      default_raise
    end

    JSON::Schema.new(@schema, @uri)
  end

  private

  def allowed_domains
    ['json-schema.org']
  end

  def read_file_to_schema
    file = Pathname.new(@uri.path).expand_path

    if file.to_s.starts_with?("#{ENV['GEM_HOME']}/gems/json-schema")
      @uri    = JSON::Util::URI.file_uri(@uri)
      body    = read_file(file)
      @schema = JSON::Validator.parse(body)
    else
      default_raise
    end
  end

  def default_raise
    raise JSON::Schema::ReadFailed.new(@uri.to_s, :uri)
  end

  def set_schema
    record     = model_map[@uri.scheme].find(@uri.host)
    @schema    = record.schema
    capture_record(@uri.scheme.underscore, record)
  rescue ActiveRecord::RecordNotFound
    default_raise
  end

  def model_map
    {
      'schema' => JSONSchema,
      'schema-version' => JSONSchemaVersion
    }
  end

  def capture_record(group, record)
    @captured_records[group] ||= []
    @captured_records[group] << record.id
    @captured_records[group].uniq!
  end
end
