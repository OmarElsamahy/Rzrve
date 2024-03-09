# frozen_string_literal: true

class Api::V1::Auth::RegistrationController < BaseApiController
  include Api::V1::Auth::DeviceManager

  skip_before_action :authorize_request, :authorize_action!
  before_action :downcase_email_params

  def create
    ActiveRecord::Base.transaction do
      @company = Company.new
      @company.assign_attributes(company_registration_params)
      @company.save!
      @manager = @company.set_company_manager(employee_registration_params, request)
      set_device(@manager, device_params)
    end
    response_json(status: :created, data: {company: @company.reload.as_json(options: serializer_options(full_details: true, is_owner: true)),
                                           manager: @manager.as_json(options: serializer_options(full_details: true, is_owner: true)),
                                           extra: {
                                             access_token: @manager.get_token(@device.id)
                                           }})
  end
end
