require_relative "boot"

require "rails/all"
require 'pdfkit'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Hipodecos
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    # options will be passed to PDFKit.new
    config.i18n.default_locale = :es
    config.i18n.enforce_available_locales = true

    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]

    config.time_zone = 'Bogota'
    config.active_record.default_timezone = :local

    config.middleware.use PDFKit::Middleware, :print_media_type => true
  end
end
