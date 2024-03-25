# frozen_string_literal: true

module ControllerHelpers
  include Api::V1::Auth::DeviceManager
  def create_token(user)
    device_params = {
      device_type: "android",
      fcm_token: "test_fcm_token"
    }

    set_device(user, device_params)
    user.get_token(@device.id)
  end
end
