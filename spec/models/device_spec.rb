# frozen_string_literal: true

require "rails_helper"

RSpec.describe Device, type: :model do
  describe "associations" do
    it { should belong_to(:authenticable) }
  end

  describe "validations" do
    it { should validate_presence_of(:fcm_token) }
  end

  describe "enums" do
    it { should define_enum_for(:device_type).with_values(unknown: 0, ios: 1, android: 2, web: 3) }
  end

  describe "scopes" do
    describe ".all_except" do
      let!(:device) { create(:device) }
      let!(:other_devices) { create_list(:device, 3) }

      it "returns all devices except the given one" do
        expect(Device.all_except(device)).to match_array(other_devices)
      end
    end
  end

  describe "methods" do
    describe "#logout_other_devices" do
      let(:authenticable) { create(:user) }
      let(:current_device) { create(:device, authenticable: authenticable) }
      let!(:other_devices) { create_list(:device, 3, authenticable: authenticable) }

      it "logs out other devices of the same authenticable" do
        expect {
          current_device.logout_other_devices
          other_devices.each(&:reload)
        }.to change { other_devices.select(&:logged_out?).count }.from(0).to(3)
      end
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
