# frozen_string_literal: true

class Api::V1::Users::ProfilesController < BaseApiController
  include Api::V1::UsersHandler
  include Api::V1::Shared::Users::ProfilesConcern

  before_action :downcase_email_params, only: :change_email

  def update
    ActiveRecord::Base.transaction do
      @current_user.assign_attributes(user_profile_params.except(:country_code, :phone_number))
      unless @current_user.country_code == user_profile_params[:country_code] && @current_user.phone_number == user_profile_params[:phone_number]
        @current_user.unconfirmed_country_code = user_profile_params[:country_code]
        @current_user.unconfirmed_phone_number = user_profile_params[:phone_number]
      end
      if @current_user.unconfirmed_country_code.present? && @current_user.unconfirmed_phone_number.present?
        @current_user.enforce_phone_verification_sms_callback = true
      end
      @current_user.save!
    end
    extra = {redirect_to_phone_verification: @current_user.saved_change_to_verification_code?,
             phone_number_to_verify: {
               country_code: @current_user.unconfirmed_country_code,
               phone_number: @current_user.unconfirmed_phone_number
             }}
    extra[:verification_code] = @current_user.verification_code if Rails.env.development?
    render_response(status: :ok,
      data: {user: @current_user.as_json(options: serializer_options(is_owner: true, full_details: true, include: params[:include]))},
      extra: extra)
  end

  def patch_update
    @current_user.update!(user_profile_params.except(:country_code, :phone_number))
    render_response
  end

  def change_email
    raise ExceptionHandler::BadRequest.new(error: "invalid_params") unless change_email_params[:email].present? && @current_user.email != change_email_params[:email]
    raise ExceptionHandler::UnprocessableEntity.new(error: "email_already_taken") if User.where(email: change_email_params[:email]).exists?
    @current_user.assign_attributes(unconfirmed_email: change_email_params[:email])
    @current_user.send_email_verification_mail
    data = Rails.env.development? ? {verification_code: @current_user.verification_code} : {}
    render_response(status: :ok, data: data)
  end

  def destroy
    @current_user.update!(status: @current_user.class.statuses[:deleted])
    @current_user.devices.destroy_all
    render_response(message: I18n.t("messages.profile.delete_account"), status: :ok)
  end
end
