# frozen_string_literal: true

class Api::V1::DeviceSerializer < BaseSerializer
  attributes :authenticable_type,
    :authenticable_id,
    :fcm_token,
    :device_type,
    :logged_out,
    :locale,
    :created_at,
    :updated_at
end
