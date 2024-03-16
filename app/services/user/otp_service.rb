# frozen_string_literal: true

class User::OtpService
  def initialize(user: nil, code_scope: "verification", otp: nil, to_verify: "email")
    @user = user
    @code_scope = code_scope
    @otp = otp.to_s
    @to_verify = to_verify
  end

  def verify_otp
    set_variables
    verify_user_data
  end

  def verify_user_data
    raise ExceptionHandler::AuthenticationError.new(error: I18n.t("errors.expired_code"), message: I18n.t("errors.expired_code")) unless DateTime.now <= @adjusted_datetime
    raise ExceptionHandler::AuthenticationError.new(error: I18n.t("errors.wrong_code"), message: I18n.t("errors.wrong_code")) unless @otp == @user_code

    payload = {}
    payload[:otp] = @otp
    payload[:confirmation_date] = DateTime.now
    payload[:email] = @verification_email
    payload[:country_code] = @verification_country_code
    payload[:phone_number] = @verification_phone_number
    payload[:code_scope] = @code_scope
    token = {}
    token[:jwt] = JsonWebToken.encode(payload)
  end

  def set_variables
    case @code_scope
    when "verification"
      set_verification_variables
    when "reset_password"
      set_reset_password_variables
    end
  end

  def set_verification_variables
    @adjusted_datetime = ((@user.verification_code_sent_at&.to_time || DateTime.now) + 130.seconds).to_datetime
    @user_code = @user.verification_code
    @verification_email = @user.email_to_verify
    @verification_country_code, @verification_phone_number = @user.phone_number_to_verify
  end

  def set_reset_password_variables
    @adjusted_datetime = ((@user.reset_password_sent_at&.to_time || DateTime.now) + 130.seconds).to_datetime
    @user_code = @user.reset_password_token
    @verification_email = @user.email
    @verification_country_code, @verification_phone_number = [@user.country_code, @user.phone_number]
  end
end
