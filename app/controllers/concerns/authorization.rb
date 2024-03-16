# frozen_string_literal: true

module Authorization
  extend ActiveSupport::Concern

  # #accept access token and set current user, don't allow guest
  def authorize_request
    set_current_user
    raise ExceptionHandler::AuthenticationError.new(error: "missing_token") if @current_user.nil?
  end

  # #accept access token and set current user or allow guest mode
  def authorize_or_allow_guest
    authorize_request
    check_verified
  rescue
    logger.debug("Guest Mode Enabled")
  end

  # #set current user from authorization header (uses JWT)
  def set_current_user
    if request.headers["Authorization"].present?
      logger.debug("IN CURRENT USER FUNCTION")
      user_object = Api::V1::Auth::AuthorizeApiRequest.new(request.headers).call
      @current_user = user_object[:user]
      @current_user_device = user_object[:device]
      @device = @current_user_device
    end
  end

  def check_verified
    if @current_user.present? && (!@current_user.email_verified? && !@current_user.phone_number_verified?)
      raise ExceptionHandler::AuthenticationError.new(error: "unverified_user")
    end
  end

  def authorize_action!
    ConsoleLogger.instance.logger.debug("ACTION: #{params[:action].to_sym}, CONTROLLER_NAME: #{params[:controller].split("/").last.to_sym}")
    authorize! params[:action].to_sym, params[:controller].split("/").last.to_sym
  end
end
