# frozen_string_literal: true

class Api::V1::Auth::AuthenticateUser
  def initialize(parameters, user_class = nil)
    @email = parameters[:email]
    @password = parameters[:password]
    @user_class = user_class
  end

  def call
    {
      user: user
    }
  end

  def user
    user = @user_class.active.find_by(email: email)
    raise ExceptionHandler::AccountNotFound.new(error: "account_not_found") if user.nil? || user.deleted_status?
    raise ExceptionHandler::AuthenticationError.new(error: "invalid_credentials") unless user&.valid_password?(@password)
    user
  end

  private

  attr_reader :email, :password
end
