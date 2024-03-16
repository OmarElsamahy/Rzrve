# frozen_string_literal: true

FactoryBot.define do
  factory :device do
    authenticable { create(:employee) }
    device_type { :android }
    fcm_token { "test_token" }
    locale { "en" }
    logged_out { false }

    trait :logged_out do
      logged_out { true }
    end
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
