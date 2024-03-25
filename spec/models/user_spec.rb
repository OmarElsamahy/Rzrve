# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  describe "validations" do
    subject { build(:user) }

    context "when status is active" do
      before { subject.status = :active }

      it { should validate_presence_of(:phone_number) }
      it { should validate_presence_of(:country_code) }
    end

    context "phone uniqueness" do
      it "validates the uniqueness of phone_number scoped to country_code" do
        user1 = create(:user, :verified)
        user2 = build(:user, phone_number: user1.phone_number, country_code: user1.country_code)
        expect(user2).not_to be_valid
        expect(user2.errors[:phone_number]).to include("has already been taken")
      end
    end

    it "validates the format of email" do
      user = build(:user, email: "invalid_email")
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("is invalid")
    end

    it { should validate_presence_of(:password) }
    it { should validate_length_of(:password).is_at_least(8) }
    it { should allow_value("valid_password123").for(:password) }
    it { should_not allow_value("weak").for(:password) }

    it { should allow_value("123456789").for(:phone_number) }
  end

  describe "associations" do
    it { should have_many(:devices).dependent(:destroy) }
  end

  describe "scopes" do
    describe ".active" do
      it "returns only active users" do
        active_user = create(:user, status: :active)
        create(:user, status: :deleted)
        expect(User.active).to include(active_user)
      end
    end

    describe ".deactivated" do
      it "returns only deactivated users" do
        deactivated_user = create(:user, status: :deactivated)
        create(:user, status: :active)
        expect(User.deactivated_status).to include(deactivated_user)
      end
    end

    describe ".deleted" do
      it "returns only deleted users" do
        deleted_user = create(:user, status: :deleted)
        create(:user, status: :active)
        expect(User.deleted_status).to include(deleted_user)
      end
    end

    describe ".suspended" do
      it "returns only suspended users" do
        suspended_user = create(:user, status: :suspended)
        create(:user, status: :active)
        expect(User.suspended_status).to include(suspended_user)
      end
    end
  end

  describe "callbacks" do
    describe "#set_account_verified_at" do
      it "sets account_verified_at when email_verified_at changes" do
        user = create(:user)
        user.update(email_verified_at: Time.now)
        expect(user.account_verified_at).to be_present
      end

      it "sets account_verified_at when phone_number_verified_at changes" do
        user = create(:user)
        user.update(phone_number_verified_at: Time.now)
        expect(user.account_verified_at).to be_present
      end
    end
  end
end

# == Schema Information
#
# Table name: users
#
#  id                        :bigint           not null, primary key
#  account_verified_at       :datetime
#  avatar                    :text
#  country_code              :string
#  current_sign_in_at        :datetime
#  current_sign_in_ip        :string
#  email                     :string
#  email_verified_at         :datetime
#  encrypted_password        :string           default(""), not null
#  last_sign_in_at           :datetime
#  last_sign_in_ip           :string
#  name                      :string
#  phone_number              :string
#  phone_number_verified_at  :datetime
#  reset_password_sent_at    :datetime
#  reset_password_token      :string
#  sign_in_count             :integer          default(0), not null
#  status                    :integer
#  unconfirmed_country_code  :string
#  unconfirmed_email         :string
#  unconfirmed_phone_number  :string
#  verification_code         :string
#  verification_code_sent_at :datetime
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
# Indexes
#
#  index_users_on_account_verified_at                       (account_verified_at)
#  index_users_on_country_code_and_phone_number_and_status  (country_code,phone_number,status) UNIQUE WHERE (status = 0)
#  index_users_on_email                                     (email) UNIQUE WHERE ((status = 0) AND (email IS NOT NULL))
#  index_users_on_email_and_status                          (email,status) UNIQUE WHERE ((status = 0) AND (email_verified_at IS NOT NULL))
#  index_users_on_reset_password_token                      (reset_password_token) UNIQUE
#  index_users_on_status                                    (status)
#
