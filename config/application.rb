require File.expand_path('../boot', __FILE__)

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
# require "active_record/railtie"
# require 'neo4j/railtie'
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ApiAppBo
  class Application < Rails::Application
    
    config.generators do |g|
      g.orm             :neo4j
    end

    # Configure where the embedded neo4j database should exist
    # Notice embedded db is only available for JRuby
    # config.neo4j.session_type = :embedded_db  # default #server_db
    # config.neo4j.session_path = File.expand_path('neo4j-db', Rails.root)

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :fr

    # Allow empty arrays as params
    config.action_dispatch.perform_deep_munge = false

    # Mailer config
    config.action_mailer.smtp_settings = {
        address: 'smtp-apiapp.alwaysdata.net',
        port: 587,
        domain: 'apiapp.alwaysdata.net',
        user_name: 'apiapp@alwaysdata.net',
        password: 'apiapp_smtp',
        authentication: 'plain',
        enable_starttls_auto: true
    }
    config.action_mailer.perform_deliveries = true
    config.action_mailer.raise_delivery_errors = true

    config.support_email = ''
  end
end
