# frozen_string_literal: true

class Api::V1::VendorSerializer < BaseSerializer
  attribute :user_type do |object|
    object.class.name.underscore
  end

  attributes :name, :email, :status, :country_code, :phone_number

  attributes :profile_status, :account_verified_at, if: proc { |_, params| params[:full_details] }

  attribute :created_at,
    :updated_at, if: proc { |_, params| params[:current_user]&.admin? }
end
