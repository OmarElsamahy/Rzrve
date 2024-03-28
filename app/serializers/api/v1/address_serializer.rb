# frozen_string_literal: true

class Api::V1::AddressSerializer < BaseSerializer
  attributes :addressable_type,
             :district,
             :full_address,
             :is_default,
             :is_hidden, :landmark, :lat,
             :long, :lookup_key, :name,
             :street_information, :created_at,
             :updated_at, :addressable_id,
             :city_id, :country_id

  attribute :vendor, if: proc { |record, params| params[:full_details] == true } do |record|
    record.vendor.as_json
  end

  attribute :address, if: proc { |record, params| params[:full_details] == true } do |record|
    record.address.as_json
  end

  attribute :created_at,
    :updated_at
end
