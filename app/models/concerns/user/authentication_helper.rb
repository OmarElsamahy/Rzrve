# frozen_string_literal: true

module User::AuthenticationHelper
  extend ActiveSupport::Concern

  included do
    normalizes :email, with: ->(email) { email.strip.downcase }

    after_save :destroy_user_devices, if: -> { respond_to?(:status?) && saved_change_to_status? && status.in?(["suspended", "deleted"]) }
  end

  def get_token(device_id)
    payload = {}
    payload[:authenticable_id] = id
    payload[:authenticable_type] = self.class.name
    payload[:device] = device_id
    payload[:created_at] = DateTime.now.to_i
    JsonWebToken.encode(payload)
  end

  private

  def destroy_user_devices
    devices.delete_all
  end
end
