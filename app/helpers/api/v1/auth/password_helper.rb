# frozen_string_literal: true

module Api::V1::Auth::PasswordHelper
  def validate_password
    validate_presence(:current_password)
    validate_current_password
    validate_password_confirmation
  end

  private

  def validate_presence(field)
    raise_bad_request("missing_params") if change_password_params[field].blank?
  end

  def validate_current_password
    raise_bad_request("invalid_credentials") unless @current_user&.valid_password?(change_password_params[:current_password])
  end

  def validate_password_confirmation
    raise_bad_request("invalid_credentials") unless password_confirmation_valid?
  end

  def password_confirmation_valid?
    change_password_params[:password] == change_password_params[:password_confirmation]
  end

  def raise_bad_request(error)
    raise ExceptionHandler::BadRequest.new(error: error)
  end

  def validate_current_password_presence
    if change_password_params[:current_password].blank?
      raise ExceptionHandler::BadRequest.new(error: "missing_params")
    end
  end
end
