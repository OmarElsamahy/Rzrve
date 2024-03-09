require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Rzrv
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    Dir["./app/middlewares/*.rb"].sort.each do |file|
      require file
    end

    Dir["./config/constants/*.rb"].sort.each do |file|
      require file
    end

    # Configuration for the application, engines, and railties goes here.
    #
    config.autoload_paths += %W[#{config.root}/config/constants]

    config.active_job.queue_adapter = :sidekiq

    config.middleware.use RequestLogger
    config.middleware.use Rack::Attack
    config.middleware.use ErrorMailerMiddleware

    config.action_mailer.raise_delivery_errors = true
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.perform_deliveries = true
    config.action_mailer.perform_caching = false
    config.action_mailer.default_url_options = {host: Rails.application.credentials.smtp[:host]}
    config.action_mailer.smtp_settings = {
      address: "smtp.gmail.com",
      port: 587,
      domain: "smtp.gmail.com",
      user_name: Rails.application.credentials.smtp[:email],
      password: Rails.application.credentials.smtp[:password],
      authentication: :plain,
      enable_starttls_auto: true
    }
  end
end
