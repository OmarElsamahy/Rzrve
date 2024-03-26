# frozen_string_literal: true

class Address < ApplicationRecord
  include LookupsHelper

  belongs_to :addressable, polymorphic: true
  belongs_to :country
  belongs_to :city

  validates_presence_of :lat, :long

end

# == Schema Information
#
# Table name: addresses
#
#  id                 :bigint           not null, primary key
#  addressable_type   :string
#  district           :string
#  full_address       :text
#  is_default         :boolean
#  is_hidden          :boolean
#  landmark           :string
#  lat                :string
#  long               :string
#  lookup_key         :string
#  name               :string
#  street_information :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  addressable_id     :bigint
#  city_id            :bigint
#  country_id         :bigint
#
# Indexes
#
#  index_addresses_on_addressable  (addressable_type,addressable_id)
#  index_addresses_on_city_id      (city_id)
#  index_addresses_on_country_id   (country_id)
#
