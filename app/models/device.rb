# frozen_string_literal: true

class Device < ApplicationRecord
  belongs_to :authenticable, polymorphic: true
  validates :fcm_token, presence: true
  enum :device_type, {unknown: 0, ios: 1, android: 2, web: 3}, default: :unknown, validate: true
  scope :all_except, ->(device) { where.not(id: device) }

  def logout_other_devices
    authenticable.devices.all_except(self).update_all(logged_out: true)
  end
end

# == Schema Information
#
# Table name: devices
#
#  id                 :bigint           not null, primary key
#  authenticable_type :string
#  device_type        :integer          default("unknown")
#  fcm_token          :text
#  locale             :string           default("en")
#  logged_out         :boolean          default(TRUE)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  authenticable_id   :bigint
#
# Indexes
#
#  index_devices_on_authenticable  (authenticable_type,authenticable_id)
#
