# frozen_string_literal: true

module Api::V1::PhoneHandler
  extend ActiveSupport::Concern

  private

  def check_phone_params
    raise ActionController::ParameterMissing.new(error: "missing_params") if params[:user][:phone_number].blank? || params[:user][:country_code].blank?
  end

  def get_phone_user
    @user = User.active.find_by(country_code: params[:user][:country_code], phone_number: params[:user][:phone_number])
    raise ExceptionHandler::AccountNotFound.new(error: "account_not_found") if @user.nil?
  end

  def check_phone_exists
    exist = User.active.verified.find_by(country_code: params[:user][:country_code], phone_number: params[:user][:phone_number]).present?
    raise ExceptionHandler::BadRequest.new(error: "invalid_params", message: "phone_already_taken") if exist
  end

  def format_phone_params
    if params[:user][:phone_number] && params[:user][:country_code]
      phone_obj = PhoneFormatter.format_phone(params[:user][:phone_number], params[:user][:country_code])
      params[:user][:country_code] = phone_obj[:country_code]
      params[:user][:phone_number] = phone_obj[:phone]
    end
  end
end
