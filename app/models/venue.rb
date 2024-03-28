# frozen_string_literal: true

class Venue < ApplicationRecord

  scope :filter_by_vendor, -> (vendor_id){
    where(vendor_id: vendor_id) if vendor_id.present?
  }

  scope :in_city, -> (city_id){
    where(city_id: city_id) if city_id.present?
  }

  has_one :address, as: :addressable, dependent: :destroy
  has_many :courts, dependent: :destroy

  belongs_to :vendor
  belongs_to :city

  accepts_nested_attributes_for :address

  validates_associated :address

end

# == Schema Information
#
# Table name: venues
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  city_id    :bigint
#  vendor_id  :bigint
#
# Indexes
#
#  index_venues_on_city_id    (city_id)
#  index_venues_on_vendor_id  (vendor_id)
#
# Foreign Keys
#
#  fk_rails_...  (city_id => cities.id)
#  fk_rails_...  (vendor_id => vendors.id)
#
