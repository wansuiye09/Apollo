if Rails.env.production?
  redis_url = ENV['REDIS_URL']
  Sidekiq.configure_server do |config|
    config.redis = {url: redis_url, db: 1}
  end

  Sidekiq.configure_client do |config|
    config.redis = {url: redis_url, db: 1}
  end
end
