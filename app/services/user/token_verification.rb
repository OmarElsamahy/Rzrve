# frozen_string_literal: true

class User::TokenVerification
  def initialize(user: nil, token: "", verification_type: "", verification_email: "", verification_country_code: "", verification_phone_number: "", code_scope: "verification")
    @user = user
    @verification_type = verification_type
    @verification_email = verification_email
    @verification_country_code = verification_country_code
    @verification_phone_number = verification_phone_number
    @token = token
    @code_scope = code_scope
  end

  def verify_token
    verify_jwt
  end

  def verify_jwt
    decoded_token = JsonWebToken.decode(@token)
    @jwt_email = decoded_token[:email]
    @jwt_country_code = decoded_token[:country_code]
    @jwt_phone_number = decoded_token[:phone_number]
    @jwt_code_scope = decoded_token[:code_scope]
    raise ExceptionHandler::InvalidToken.new(error: "invalid_token") if falsy_token
    attributes_to_update_hash = (@verification_type == "email") ? {email_verified_at: DateTime.now} : {phone_number_verified_at: DateTime.now}
    [attributes_to_update_hash, {}]
  end

  def falsy_token
    return @jwt_email.nil? || @jwt_email != @verification_email || @code_scope != @jwt_code_scope if @verification_type == "email"
    @jwt_country_code.nil? || @jwt_phone_number.nil? || @jwt_country_code != @verification_country_code ||
      @jwt_phone_number != @verification_phone_number || @code_scope != @jwt_code_scope
  end
end
