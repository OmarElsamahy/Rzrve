# frozen_string_literal: true

class Api::V1::Auth::PasswordsController < BaseApiController
  include Api::V1::UsersHandler
  include Api::V1::Auth::PasswordHelper
  include Api::V1::Auth::DeviceManager

  skip_before_action :authorize_request, :authorize_action!, except: [:change_password, :is_valid]
  before_action :set_user_model, except: [:is_valid, :change_password]
  before_action :validate_current_password, :validate_current_password_presence, only: :change_password
  before_action :downcase_email_params, :set_controller_user, except: [:is_valid, :change_password]

  def check_exists
    render_response
  end

  def is_valid
    raise ExceptionHandler::UnprocessableEntity.new(error: "invalid_password") unless @current_user.valid_password?(params[:password])
    render_response
  end

  def send_reset_password_info
    @user.send_reset_password_email
    data = Rails.env.development? ? { reset_password_token: @user.reset_password_token } : {}
    render_response(status: :ok, data: data)
  end

  def verify_otp
    token = User::OtpService.new(user: @user, code_scope: "reset_password", otp: params[:verification_code]).verify_otp
    @user.save!
    render_response(data: { token: token })
  end

  def reset_password
    @user = User::ResetPasswordService.new(
      user: @user,
    ).reset_password(
      password: reset_password_params[:password],
      password_confirmation: reset_password_params[:password_confirmation],
      token: request.headers["verification-token"].to_s,
      verify: true,
    )
    return raise ActiveRecord::RecordInvalid.new(@user) if @user.errors.any?
    ActiveRecord::Base.transaction do
      set_device(@user, device_params)
      @user.save!
      @device.logout_other_devices
    end
    render_response(status: :ok, data: { user: @user.as_json(options: serializer_options(full_details: true, is_owner: true)),
                                         device: @device.as_json,
                                         extra: { access_token: @user.get_token(@device.id) } })
  end

  def change_password
    @user = User::ResetPasswordService.new(
      user: @current_user,
    ).reset_password(
      password: change_password_params[:password],
      password_confirmation: change_password_params[:password_confirmation],
      verify: false,
    )
    render_response
  end

  private

  def set_controller_user
    @user = @user_class.verified.active.find_by(country_code: password_params[:country_code], phone_number: password_params[:phone_number])
    render_error(message: I18n.t("errors.account_not_found"), error: I18n.t("errors.account_not_found"), status: :not_found) unless @user.present?
  end
end
