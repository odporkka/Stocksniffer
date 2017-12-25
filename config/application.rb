require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Stocksniffer
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.autoload_paths += Dir["#{Rails.root}/lib"]

    if Rails.env == 'test'
      require File.expand_path("../diagnostic.rb", __FILE__)
      config.middleware.use(Stocksniffer::DiagnosticMiddleware)
    end

    # Setup active_job
    config.active_job.queue_adapter = :delayed_job
  end
end
