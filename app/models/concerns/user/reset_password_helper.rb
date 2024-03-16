# frozen_string_literal: true

module User::ResetPasswordHelper
  extend ActiveSupport::Concern

  def generate_reset_password_code
    code = generate_code(code_size: 6)
    self.reset_password_token = code
    self.reset_password_sent_at = DateTime.now + 15.seconds
  end

  def send_reset_password_email
    generate_reset_password_code
    VerificationMailer.with(user: self, verification_code: reset_password_token, email: email).reset_password_verification.deliver_later
    save!
  end
end
