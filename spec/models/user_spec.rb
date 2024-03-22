# spec/models/user_spec.rb
require "rails_helper"

RSpec.describe User, type: :model do
  describe "validations" do
    subject { build(:user) }

    it { should validate_presence_of(:email) }
    context "email uniqueness" do
      it "validates uniqueness when status is active" do
        passing_user = create(:user, status: :active)
        puts passing_user.as_json
        puts passing_user.persisted?
        puts "passing_user"
        non_passing_user = create(:user, status: :active, email: passing_user.email)
        puts non_passing_user.as_json
        puts non_passing_user.persisted?
        puts "non_passing_user"

        expect(passing_user).to be_valid
        expect(non_passing_user).not_to be_valid
      end
    end

    it "validates the format of email" do
      user = build(:user, email: "invalid_email")
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("is invalid")
    end
    it { should validate_presence_of(:password) }
    it { should validate_length_of(:password).is_at_least(8) }
    it { should allow_value('valid_password123').for(:password) }
    it { should_not allow_value('weak').for(:password) }

    it { should allow_value('123456789').for(:phone_number) }
  end

  describe "associations" do
    # it { should have_many(:devices).dependent(:destroy) }
  end

  describe "scopes" do
  end

  describe "methods" do
  end

  describe "callbacks" do
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
#  email                     :string           default(""), not null
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
#  index_users_on_email                                     (email) UNIQUE WHERE (status = 0)
#  index_users_on_email_and_status                          (email,status) UNIQUE WHERE ((status = 0) AND (email_verified_at IS NOT NULL))
#  index_users_on_reset_password_token                      (reset_password_token) UNIQUE
#  index_users_on_status                                    (status)
#
