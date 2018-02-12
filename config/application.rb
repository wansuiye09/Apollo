require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# Load configuration values.
Dotenv::Railtie.load if defined?(Dotenv::Railtie)

module Apollo
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    # Locales
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '{**/**/**/}', '*.{rb,yml}')]

    # UUID Primary Keys
    config.generators do |gen|
      gen.orm :active_record, primary_key_type: :uuid
    end

    # Use Pry for the console
    console do
      require 'pry'
      config.console = Pry
      TOPLEVEL_BINDING.eval('self').extend Rails::ConsoleMethods

      # Development helpers in the console
      unless Rails.env.production?
        TOPLEVEL_BINDING.eval('self').extend FactoryBot::Syntax::Methods
      end
    end

    # Use Sidekiq for ActiveJob
    config.active_job.queue_adapter = :sidekiq
  end
end
