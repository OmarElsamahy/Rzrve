# frozen_string_literal: true

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

    config.autoload_paths += %W[#{config.root}/config/constants]
    config.i18n.load_path += Dir[Rails.root.join("config/locales/**/*.{rb,yml}")]

    config.i18n.available_locales = AVAILABLE_LOCALES
    config.i18n.default_locale = :en
    config.i18n.fallbacks = true
    config.i18n.fallbacks = [:en]
    config.i18n.fallbacks = (AVAILABLE_LOCALES - [:en]).map { |x| [x, :en] }.to_h

    config.active_job.queue_adapter = :sidekiq
    config.action_mailer.deliver_later_queue_name = "critical"

    config.middleware.use RequestLogger
    config.middleware.use SetLanguage

    config.action_mailer.raise_delivery_errors = true
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.perform_deliveries = true
    config.action_mailer.perform_caching = false
    # config.action_mailer.default_url_options = {host: Rails.application.credentials.smtp[:host]}
    config.action_mailer.smtp_settings = {
      address: "smtp.gmail.com",
      port: 587,
      domain: "smtp.gmail.com",
      # user_name: Rails.application.credentials.smtp[:email],
      # password: Rails.application.credentials.smtp[:password],
      authentication: :plain,
      enable_starttls_auto: true
    }
  end
end
