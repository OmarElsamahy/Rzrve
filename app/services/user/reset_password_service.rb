# frozen_string_literal: true

class User::ResetPasswordService
  def initialize(user: nil)
    @user = user
  end

  def reset_password(password: nil, password_confirmation: nil, token: nil, verify: true)
    verify_reset_password(token) if verify
    unless password == password_confirmation && @user.reset_password(password, password_confirmation)
      raise ExceptionHandler::BadRequest.new(error: "invalid_password")
    end
    @user
  end

  def verify_reset_password(token)
    _, extra_data = User::TokenVerification.new(
      user: @user,
      token: token,
      verification_type: "phone_number",
      verification_phone_number: @user.phone_number,
      verification_country_code: @user.country_code,
      code_scope: "reset_password",
    ).verify_token
    @user.assign_attributes(reset_password_data.merge(extra_data))
  end

  def reset_password_data
    {
      reset_password_token: nil,
      reset_password_sent_at: nil,
    }
  end
end
