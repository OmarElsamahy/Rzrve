source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.3.0"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.1.3.2"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 6.0"

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Redis adapter to run Action Cable in production
gem "redis"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false
# Phone numbers
gem "global_phone"
gem "phonelib"
# Code quality
gem "standard", "~> 1.3"
gem "standard-rails"
# Pagination
gem "kaminari"
# Serializer
gem "jsonapi-serializer"
# Active_job adapter
gem "sidekiq", "~> 7.2"
# devise for users
gem "devise", "~> 4.9.3"
# for deployment
gem "vlad"
gem "vlad-git"
# for auth
gem "jwt"
# for cors
gem "rack-cors"
# Admin panel
gem "activeadmin"
gem "activeadmin_addons"
gem "activeadmin_dynamic_fields"
gem "activeadmin-searchable_select"
gem "arctic_admin"
gem "formtastic", "~> 4.0"
gem "select2-rails", "~> 4.0"
# active admin html editor
# gem 'active_admin_editor', git: 'https://github.com/boontdustie/active_admin_editor'
# gem 'activeadmin_froala_editor'
# For map
# gem 'activeadmin_latlng'
# Authorization
gem "cancancan"
# rate limiting
gem "rack-attack"
# For uploads
gem "inova_aws_s3", "~> 0.5.0"
# For translations
gem "mobility", "~> 1.2.9"
# For Search in translation
gem "mobility-ransack"
# Localization
gem "rails-i18n"
# For Firebase Cloud Messaging
gem "inova_fcm", "~> 0.2.0"
# For Third party
gem "httparty"
# Use Sass to process CSS
# gem "sassc-rails"
# geocode
gem "geokit-rails"

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"
# For Ordering
gem "acts_as_list"

# firebase
gem "firebase"

# logs
gem "rainbow"

# dynamic links
gem "inova_dynamic_link", "~> 0.2.2"

# mocks
gem "mocha"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "annotate"
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem "rubocop", require: false
  gem "rubocop-performance"
  gem "rubocop-rails"
  gem "rubocop-rspec"
  gem "faker"
  gem "byebug", "~> 11.1"
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  gem "spring"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
  gem "rspec"
  gem "simplecov", require: false
end
