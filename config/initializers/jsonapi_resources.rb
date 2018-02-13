JSONAPI.configure do |config|
  #:underscored_key, :camelized_key, :dasherized_key, or custom
  config.json_key_format = :dasherized_key

  #:underscored_route, :camelized_route, :dasherized_route, or custom
  config.route_format = :dasherized_route

  #:integer, :uuid, :string, or custom (provide a proc)
  config.resource_key_type = :uuid

  # Resource cache
  # An ActiveSupport::Cache::Store or similar, used by Resources with caching enabled.
  # Set to `nil` (the default) to disable caching, or to `Rails.cache` to use the
  # Rails cache store.
  config.resource_cache = Rails.cache
end
