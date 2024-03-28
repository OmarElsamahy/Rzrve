# frozen_string_literal: true

class City < ApplicationRecord
  include LookupsHelper

  scope :filter_by_country, ->(country_id) { where(country_id: country_id) if country_id.present? }

  belongs_to :country

  validates :lookup_key, uniqueness: { allow_blank: true }
end

# == Schema Information
#
# Table name: cities
#
#  id         :bigint           not null, primary key
#  lookup_key :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  country_id :bigint
#
# Indexes
#
#  index_cities_on_country_id  (country_id)
#
# Foreign Keys
#
#  fk_rails_...  (country_id => countries.id)
#
