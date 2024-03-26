# frozen_string_literal: true

class Venue < ApplicationRecord

  has_one :address, as: :addressable, dependent: :destroy
  has_many :courts, dependent: :destroy

  belongs_to :vendor

end

# == Schema Information
#
# Table name: venues
#
#  id        :bigint           not null, primary key
#  vendor_id :bigint
#
# Indexes
#
#  index_venues_on_vendor_id  (vendor_id)
#
# Foreign Keys
#
#  fk_rails_...  (vendor_id => vendors.id)
#
