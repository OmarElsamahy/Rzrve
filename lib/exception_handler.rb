# frozen_string_literal: true

module ExceptionHandler
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

  class FirebaseDataBaseError < BaseException; end
end
