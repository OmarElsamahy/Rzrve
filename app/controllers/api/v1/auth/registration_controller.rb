# frozen_string_literal: true

class Api::V1::Auth::RegistrationController < BaseApiController
  include Api::V1::Auth::DeviceManager
  include Api::V1::PhoneHandler

  skip_before_action :authorize_request, :authorize_action!
  before_action :downcase_email_params

  def create
    ActiveRecord::Base.transaction do
      @user = User.new
      @user.assign_attributes(registration_params)
      @user.unconfirmed_email = @user.email
      @user.unconfirmed_country_code = @user.country_code
      @user.unconfirmed_phone_number = @user.phone_number
      @user.update_tracked_fields(request)
      set_device(@user, device_params)
      @user.save!
    end
    render_response(status: :created, data: {user: @user.reload.as_json(options: serializer_options(full_details: true, is_owner: true)),
                                             device: @device.as_json,
                                             extra: {
                                               access_token: @user.get_token(@device.id)
                                             }})
  end
end
