# frozen_string_literal: true

class Api::V1::Auth::AuthorizeApiRequest
  def initialize(headers = {})
    @headers = headers
  end

  def call
    {
      user: user,
      device: device
    }
  end

  private

  attr_reader :headers

  def user
    decoded_token = decoded_auth_token
    user_class = decoded_token[:authenticable_type]&.camelcase&.safe_constantize
    @user ||= user_class.find_by(id: decoded_token[:authenticable_id]) if decoded_token
    raise ExceptionHandler::InvalidToken.new(error: "invalid_token") unless @user
    @user
  end

  def device
    @device = Device.find_by(id: decoded_auth_token[:device]) if decoded_auth_token
    raise ExceptionHandler::InvalidToken.new(error: "invalid_token") unless @device
    raise ExceptionHandler::InvalidToken.new(error: "unauthorized") if @device.logged_out
    @device
  end

  def decoded_auth_token
    @decoded_auth_token ||= JsonWebToken.decode(http_auth_header)
  end

  def http_auth_header
    return headers["Authorization"].split(" ").last if headers["Authorization"].present?
    raise ExceptionHandler::MissingToken.new(error: "missing_token")
  end
end
