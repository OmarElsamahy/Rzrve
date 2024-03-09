# frozen_string_literal: true

module ExceptionHandler
  extend ActiveSupport::Concern

  class BaseException < StandardError
    attr_reader :error
    attr_reader :message
    attr_reader :data

    def initialize(error: "", message: "", data: {})
      @message = message.presence || I18n.t("errors.#{error}")
      @error = error
      @data = data
    end
  end

  # Define custom error subclasses - rescue catches `StandardErrors`
  class AuthenticationError < BaseException; end

  class MissingToken < BaseException; end

  class InvalidToken < BaseException; end

  class BadRequest < BaseException
    attr_reader :invalid_parameter
    attr_reader :allowed_values

    def initialize(error: "", message: "", invalid_parameter: nil, allowed_values: nil)
      super(error: error, message: message)
      @invalid_parameter = invalid_parameter
      @allowed_values = allowed_values
    end
  end

  class AccountNotFound < BaseException; end

  class UnAuthorized < BaseException; end

  class AccountNotVerified < BaseException; end

  class DuplicateRecord < BaseException; end

  class Forbidden < BaseException; end

  class UnprocessableEntity < BaseException; end

  class InvalidReflection < BaseException; end

  class ResourceAlreadyAltered < BaseException; end

  class InvalidUserData < BaseException; end

  included do
    rescue_from StandardError, with: :default_error
    rescue_from ExceptionHandler::AuthenticationError, with: :unauthorized_request
    rescue_from ExceptionHandler::AccountNotFound, with: :not_found
    rescue_from ExceptionHandler::MissingToken, with: :unauthorized_request
    rescue_from ExceptionHandler::InvalidToken, with: :unauthorized_request
    rescue_from ExceptionHandler::AccountNotVerified, with: :unprocessable_entity
    rescue_from ExceptionHandler::InvalidUserData, with: :unprocessable_entity
    rescue_from ExceptionHandler::BadRequest, with: :bad_request
    rescue_from ExceptionHandler::Forbidden, with: :access_forbidden
    rescue_from ExceptionHandler::DuplicateRecord, with: :unprocessable_entity
    rescue_from ActionController::ParameterMissing, with: :missing_parameters
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    rescue_from ActiveRecord::RecordInvalid, with: :record_not_valid
    rescue_from ExceptionHandler::UnprocessableEntity, with: :unprocessable_entity
    rescue_from CanCan::AccessDenied, with: :can_can_forbidden
    rescue_from ExceptionHandler::InvalidReflection, with: :invalid_reflection
    rescue_from ActiveRecord::DeleteRestrictionError, with: :delete_restrict_error
    rescue_from ExceptionHandler::ResourceAlreadyAltered, with: :resource_conflict
    rescue_from ActionController::UnknownFormat, with: :not_acceptable
    rescue_from ActionController::MethodNotAllowed, with: :method_not_allowed
    rescue_from ActionController::InvalidAuthenticityToken, with: :unprocessable_entity
    rescue_from I18n::MissingInterpolationArgument, with: :missing_interpolation_argument
    rescue_from ActiveRecord::StatementInvalid, with: :invalid_sql_statement
    rescue_from SocketError,
      Timeout::Error,
      Errno::ECONNREFUSED,
      Errno::ETIMEDOUT,
      with: :service_unavailable
    rescue_from NoMethodError,
      NameError,
      ArgumentError,
      ActiveRecord::PreparedStatementInvalid,
      ActiveRecord::RecordNotSaved,
      ActiveRecord::ReadOnlyRecord,
      ActiveRecord::Rollback,
      ActiveRecord::RecordNotDestroyed,
      ActiveRecord::ReadOnlyRecord,
      ActiveRecord::RecordNotUnique,
      with: :internal_server_error
    rescue_from ActionDispatch::Http::Parameters::ParseError, with: :invalid_parameters
  end

  private

  WARNING_EXCEPTIONS = ["ActiveRecord::RecordInvalid",
    "ActiveRecord::RecordNotFound",
    "ActionController::UnknownFormat",
    "ActionController::MethodNotAllowed",
    "ActiveRecord::DeleteRestrictionError",
    "CanCan::AccessDenied",
    "ActionDispatch::Http::Parameters::ParseError"].freeze

  def log(e, method)
    log_error_to_console(e)
    log_error_to_sentry(e, method)
  end

  def log_error_to_sentry(exception, method)
    except_logger.info("#{method.to_s.humanize} #{exception.message}")
    except_logger.info("Full trace #{exception.backtrace.join("\n")}")
  end

  def log_error_to_console(exception)
    if exception.class.name.match?("ExceptionHandler::") || exception.class.name.in?(WARNING_EXCEPTIONS)
      logger.warn("#{exception.class.name} (#{exception.message})")
    else
      logger.error("#{exception.class.name} (#{exception.message}):\n\t\t\t\t\t       #{exception.backtrace.take(5).join("\n\t\t\t\t\t       ")}")
    end
  end

  def four_twenty_two(e)
    log(e, __method__)
    error = e.respond_to?(:error) ? e.error : e.message
    response_json_error(error: error, error_type: e.class.name, message: e.message, backtrace: e.backtrace.take(5), status: :unprocessable_entity)
  end

  def unprocessable_entity(e)
    log(e, __method__)
    error = e.respond_to?(:error) ? e.error : e.message
    response_json_error(error: error, message: e.message, status: :unprocessable_entity)
  end

  def something_went_wrong(e)
    log(e, __method__)
    response_json_error(error: "Something went wrong", message: "Something went wrong", status: :unprocessable_entity)
  end

  def unauthorized_request(e)
    log(e, __method__)
    response_json_error(error: e.error, message: e.message, data: e.data, status: :unauthorized)
  end

  def bad_request(e)
    log(e, __method__)
    error = (e.error.blank? || e.error == "invalid_params") ? "BAD_REQUEST" : e.error
    response_json_bad_request(error: error, message: e.message, invalid_parameter: e.invalid_parameter, allowed_values: e.allowed_values)
  end

  def invalid_parameters(e)
    log_error_to_console(e)
    head :bad_request
  end

  def missing_parameters(e)
    log(e, __method__)
    error = e.respond_to?(:error) ? e.error : e.message
    response_json_error(error: error, message: e.message, status: :unprocessable_entity)
  end

  def not_found(e)
    log(e, __method__)
    error = e.respond_to?(:error) ? e.error : e.message
    response_json_error(error: error, message: e.message, status: :not_found)
  end

  def record_not_found(e)
    log(e, __method__)
    error = e.respond_to?(:error) ? e.error : e.message
    response_json_error(error: error, message: I18n.t("errors.record_not_found"), status: :not_found)
  end

  def access_forbidden(e)
    log(e, __method__)
    response_json_error(error: e.error, message: e.message, data: e.data, status: :forbidden)
  end

  def can_can_forbidden(e)
    log(e, __method__)
    respond_to do |format|
      format.json {
        render json: {error: "action_unauthorized",
                      message: I18n.t("errors.action_unauthorized"),
                      subject: e.subject,
                      action: e.action,
                      conditions: e.conditions}, status: :forbidden
      }
      format.html { redirect_to "/admin", error: I18n.t("errors.action_unauthorized") }
      flash[:notice] = I18n.t("errors.action_unauthorized")
    end
  end

  def invalid_reflection(e)
    log(e, __method__)
    error = e.respond_to?(:error) ? e.error : e.message
    response_json_error(error: error, message: e.message, status: :bad_request)
  end

  def resource_conflict(e)
    log(e, __method__)
    error = e.respond_to?(:error) ? e.error : e.message
    response_json_error(error: error, message: e.message, status: :conflict)
  end

  def default_error(e)
    logger.fatal("UNHANDLED EXCEPTION: #{e.class.name}, MESSAGE: #{e.message}")
    logger.fatal("SWALLOWING AND RETURNING INTERNAL SERVER ERROR")
    log(e, __method__)
    internal_server_error(e, unhandled: true)
  end

  def internal_server_error(e, unhandled: false)
    log(e, __method__)
    error = e.respond_to?(:error) ? e.error : e.message
    response_json_error(error: error,
      message: I18n.t("errors.something_went_wrong"),
      error_type: e.class.name,
      unhandled: unhandled,
      backtrace: e.backtrace.take(5),
      status: :internal_server_error)
  end

  def record_not_valid(e)
    log(e, __method__)
    render json: {error: "VALIDATION_FAILED",
                  message: e.message,
                  record: {is_persisted: !e.record.new_record?, id: e.record.id, type: e.record.class.name.underscore}}, status: :unprocessable_entity
  end

  def not_acceptable(e)
    log(e, __method__)
    render json: {error: "NOT_ACCEPTABLE",
                  message: I18n.t("errors.not_acceptable"),
                  supported_formats: ["application/json"]}, status: :not_acceptable
  end

  def service_unavailable(e)
    log(e, __method__)
    response_json_error(error: "SERVICE_UNAVAILABLE",
      message: I18n.t("errors.service_unavailable"),
      error_type: e.class.name,
      backtrace: e.backtrace.take(5),
      status: :service_unavailable)
  end

  def method_not_allowed(e)
    log(e, __method__)
    render json: {error: "METHOD_NOT_ALLOWED",
                  message: I18n.t("errors.method_not_allowed"),
                  supported_formats: ["application/json"]}, status: :method_not_allowed
  end

  def missing_interpolation_argument(e)
    log(e, __method__)
    render json: {error: "MISSING_INTERPOLATION_ARGUMENT",
                  message: I18n.t("errors.something_went_wrong"),
                  error_type: e.class.name,
                  developer_message: e.message,
                  key: e.key}, status: :internal_server_error
  end

  def invalid_sql_statement(e)
    log(e, __method__)
    render json: {error: e.message,
                  message: I18n.t("errors.something_went_wrong"),
                  error_type: e.class.name,
                  sql_statement: e.sql,
                  backtrace: e.backtrace.take(5)}, status: :internal_server_error
  end

  def delete_restrict_error(e)
    log(e, __method__)
    render json: {error: "DEPENDENT_RELATIONS_WATCHDOG_FAILURE",
                  message: I18n.t("errors.delete_restriction_error", reflection_name: e.humanized_reflection_name),
                  error_type: e.class.name}, status: :unprocessable_entity
  end

  def except_logger
    Logger.new("#{Rails.root.join("log/exceptions.log")}")
  end
end
