# frozen_string_literal: true

module JsonWebToken
  SECRET_KEY = Rails.application.credentials.secret_key_base.to_s

  def self.encode(payload, exp = nil)
    exp = Time.now.to_i + 100.years.to_i if exp.nil?
    payload[:exp] = exp
    JWT.encode(payload, SECRET_KEY, "HS256")
  end

  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY, true, algorithm: "HS256")[0]
    ActiveSupport::HashWithIndifferentAccess.new decoded
  rescue JWT::VerificationError
    raise ExceptionHandler::InvalidToken.new(error: "invalid_token")
  rescue JWT::DecodeError
    raise ExceptionHandler::InvalidToken.new(error: "invalid_token")
  end
end
