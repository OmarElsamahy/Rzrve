# frozen_string_literal: true

module SystemCacheInvalidationHelper
  extend ActiveSupport::Concern

  included do
    after_save :invalidate_cached_data
    after_commit :invalidate_cached_data
  end

  private

  def invalidate_cached_data
    Rails.cache.delete(self.class.cache_key_for(key, company_id))
    Rails.cache.delete(self.class.cache_key_for(:all_records, company_id))
  end
end
