# frozen_string_literal: true

module ResponseHelper
  def response_json(message: I18n.t("success"), status: :ok, data: {}, extra: {})
    json_response = {message: message, data: data}
    extra = extra.merge(@pagination_info) if @pagination_info.present?
    json_response = json_response.merge(extra: extra) if extra.present?
    render json: json_response, status: status
  end

  def response_json_error(error: "", message: "", status: :unprocessable_entity, data: {}, backtrace: nil, error_type: nil, unhandled: false)
    response = {error: error, message: message}
    response[:data] = data if data.present?
    response[:exception_type] = error_type if error_type.present?
    response[:unhandled_exception] = true if unhandled
    response[:backtrace] = backtrace if backtrace.present?
    render json: response, status: status
  end

  def response_json_bad_request(message: I18n.t("errors.bad_request"), error: "BAD_REQUEST", status: :bad_request, invalid_parameter: nil, allowed_values: nil)
    response = {error: error, message: message}
    response[:invalid_parameter] = invalid_parameter if invalid_parameter.present?
    response[:allowed_values] = allowed_values.is_a?(Array) ? allowed_values : [allowed_values] if allowed_values.present?
    render json: response, status: status
  end

  def response_record_error(record)
    render json: {error: "VALIDATION_FAILED",
                  message: "Validation failed: #{record.errors.full_messages.join(", ")}"}, status: :unprocessable_entity
  end

  def serializer_options(full_details: false, is_owner: false, **kwargs)
    {params: {full_details: full_details, current_user: @current_user, is_owner: is_owner, **kwargs}}
  end
end
