# frozen_string_literal: true

module Api::V1::Auth::DeviceManager
  def set_device(user, device_params)
    raise ExceptionHandler::BadRequest.new(error: "missing_params") unless device_params.present?
    @device = user.devices.find_or_initialize_by(device_type: device_params[:device_type], fcm_token: device_params[:fcm_token])
    @device.assign_attributes(device_params)
    @device.logged_out = false
    @device.save!
    @device
  end
end
