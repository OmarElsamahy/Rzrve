# frozen_string_literal: true

class Api::V1::VenueSerializer < BaseSerializer

  attribute :vendor, if: proc { |record, params| params[:full_details] == true } do |record|
    record.vendor.as_json
  end

  attribute :address, if: proc { |record, params| params[:full_details] == true } do |record|
    record.address.as_json
  end

  attribute :created_at,
    :updated_at
end
