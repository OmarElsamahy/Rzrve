# frozen_string_literal: true

module SystemConfigurationCacheHelper
  extend ActiveSupport::Concern

  private_class_method

  def self.nearby_search_radius
    Rails.cache.fetch(cache_key_for(:nearby_search_radius)) do
      fetch_or_create_config("nearby_search_radius", 5, "Nearby search radius in kilometers").to_i
    end
  end

  def self.fetch_or_create_config(key, value, description = nil)
    config = find_or_create_by!(key: key) do |system_configuration|
      system_configuration.value = value
      system_configuration.description = description
    end
    config.value
  end

end
