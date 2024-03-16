# frozen_string_literal: true

module Api::V1::UsersHandler
  extend ActiveSupport::Concern

  private

  def set_user_model
    @user_class = params[:user_type]&.camelcase&.safe_constantize
    raise ExceptionHandler::BadRequest.new(error: "invalid_params") unless @user_class.present?
  end

  def set_user
    @user = @user_class.find(params[:user_id])
  end
end
