# frozen_string_literal: true

class SystemConfiguration < ApplicationRecord
  include SystemCacheInvalidationHelper
  include SystemConfigurationCacheHelper

  KEYS_WITH_NUMERIC_VALUES_HASH = {
  }.freeze

  validates :key, :value, presence: true
  validates :key, uniqueness: true
end

# == Schema Information
#
# Table name: system_configurations
#
#  id          :bigint           not null, primary key
#  description :string
#  key         :string
#  value       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  company_id  :bigint           not null
#
# Indexes
#
#  index_system_configurations_on_company_id  (company_id)
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#
