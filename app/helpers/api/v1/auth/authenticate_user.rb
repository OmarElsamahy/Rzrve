# frozen_string_literal: true

class Api::V1::Auth::AuthenticateUser
  def initialize(parameters, user_class = nil)
    @email = parameters[:email]
    @phone_number = parameters[:phone_number]
    @country_code = parameters[:country_code]
    @password = parameters[:password]
    @user_class = user_class
  end

  def call
    {
      user: user,
    }
  end

  def user
    user = find_user_by_email || find_user_by_phone
    raise ExceptionHandler::AccountNotFound.new(error: "account_not_found") if user.nil? || user.deleted_status?
    raise ExceptionHandler::AccountNotVerified.new(error: "account_unverified") unless user.is_verified?
    raise ExceptionHandler::AuthenticationError.new(error: "invalid_credentials") unless user.valid_password?(@password)
    user
  end

  private

  def find_user_by_email
    return nil unless @email
    @user_class.active.find_by(email: @email)
  end

  def find_user_by_phone
    return nil unless @country_code && @phone_number
    @user_class.active.find_by(country_code: @country_code, phone_number: @phone_number)
  end

  private

  attr_reader :email, :password, :country_code, :phone_number
end
