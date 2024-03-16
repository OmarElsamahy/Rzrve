# frozen_string_literal: true

class VerificationMailer < ApplicationMailer
  def email_verification
    @user = params[:user]
    @code = params[:verification_code]
    @email = params[:email]
    @email = @user.email if @email.nil?
    mail(to: @email, subject: "Rzrv Verification email")
  end

  def reset_password_verification
    @user = params[:user]
    @code = params[:verification_code]
    @email = params[:email]
    @email = @user.email if @email.nil?
    mail(to: @email, subject: "Rzrv Reset Password Verification")
  end
end
