# frozen_string_literal: true

require "rails_helper"

RSpec.describe Api::V1::Auth::PasswordsController, type: :controller do
  def create_reset_password_token(user)
    user.send_reset_password_email
    user.reset_password_token
  end

  def create_verification_token(user)
    otp = create_reset_password_token(user)
    User::OtpService.new(user: user, code_scope: "reset_password", otp: otp).verify_otp
  end
end
