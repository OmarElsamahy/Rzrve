# frozen_string_literal: true

class Api::V1::Auth::SessionsController < BaseApiController
  include Api::V1::UsersHandler
  include Api::V1::Auth::DeviceManager

  skip_before_action :authorize_request, :authorize_action!, only: [:create, :verify_token_authenticity]

  before_action :set_user_model, :downcase_email_params, only: :create

  def create
    @user = Api::V1::Auth::AuthenticateUser.new(login_params, @user_class).user
    set_device(@user, device_params)
    @user.update_tracked_fields(request)
    @user.save!
    render_response(status: :created, data: { user: @user.as_json(options: serializer_options(full_details: true, is_owner: true)), device: @device.as_json,
                                              extra: { access_token: @user.get_token(@device.id) } })
  end

  def destroy
    @current_user_device&.destroy
    render_response(message: I18n.t("messages.logged_out"), status: :ok)
  end

  def verify_token_authenticity
    if request.headers["Authorization"].present?
      Api::V1::Auth::AuthorizeApiRequest.new(request.headers).call
    end
  rescue => e
    raise ExceptionHandler::UnprocessableEntity.new(error: e.message, message: I18n.t("errors.something_went_wrong"))
  end

  def set_device_locale
    @current_user_device.update!(locale: I18n.locale)
    render json: {}, status: :ok
  end
end
