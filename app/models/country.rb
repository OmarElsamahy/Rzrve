# frozen_string_literal: true

class Country < ApplicationRecord
  include LookupsHelper
  validates :lookup_key, uniqueness: {allow_blank: true}
end

# == Schema Information
#
# Table name: countries
#
#  id         :bigint           not null, primary key
#  iso_code   :string
#  lookup_key :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_countries_on_iso_code    (iso_code) UNIQUE
#  index_countries_on_lookup_key  (lookup_key) UNIQUE
#
