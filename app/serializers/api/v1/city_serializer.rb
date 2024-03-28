# frozen_string_literal: true

class Api::V1::CitySerializer < BaseSerializer

  attributes :name, :lookup_key, :country_id

  attribute :country, if: proc { |record, params| params[:full_details] == true} do |record|
    record.country.as_json
  end

  attribute :created_at,
    :updated_at, if: proc { |_, params| params[:current_user]&.admin? }
end
