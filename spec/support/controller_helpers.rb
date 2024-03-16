# frozen_string_literal: true

module ControllerHelpers
  include Api::V1::Auth::DeviceManager
  def create_token(employee)
    device_params = {
      device_type: "android",
      fcm_token: "test_fcm_token"
    }

    set_device(employee, device_params)
    employee.get_token(@device.id)
  end
end
