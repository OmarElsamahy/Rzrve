# frozen_string_literal: true

class Api::V1::CountrySerializer < BaseSerializer

  attributes :name, :iso_code, :lookup_key

  attribute :created_at,
    :updated_at, if: proc { |_, params| params[:current_user]&.admin? }
end
