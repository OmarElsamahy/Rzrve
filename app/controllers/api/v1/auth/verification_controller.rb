# frozen_string_literal: true

class Api::V1::Auth::VerificationController < BaseApiController
  skip_before_action :check_verified
  before_action :validate_verification_type_param

  def send_verification_info
    case @verification_type
    when "email"
      @current_user.send_email_verification_mail
    when "phone_number"
      @current_user.send_phone_verification_sms
    end
    data = Rails.env.development? ? {verification_code: @current_user.verification_code} : {}
    render_response(status: :ok, data: data)
  end

  def verify
    token = User::OtpService.new(user: @current_user, code_scope: "verification", otp: params[:verification_code]).verify_otp
    @current_user = User::VerificationService.new(user: @current_user, verification_type: @verification_type).verify(token)
    @current_user.save!
    render_response(data: {user: @current_user.as_json(options: serializer_options(full_details: true, is_owner: true)), extra: {access_token: @current_user.get_token(@current_user_device.id)}})
  end

  private

  def validate_verification_type_param
    raise ExceptionHandler::BadRequest.new(error: "invalid_params") unless %w[email phone_number].include?(params[:verification_type].to_s)
    @verification_type = params[:verification_type].to_s
  end
end
