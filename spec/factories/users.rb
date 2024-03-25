# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { "Testtest1@" }
    password_confirmation { "Testtest1@" } # Ensure password_confirmation matches password
    status { :active }
    country_code { "+20" }
    phone_number { "10" + Faker::Number.number(digits: 8).to_s }
    name { Faker::Name.name }

    trait :with_invalid_password do
      password { "weak" } # For testing invalid password
      password_confirmation { "weak" } # Ensure password_confirmation matches password
    end

    trait :verified do
      phone_number_verified_at {DateTime.current}
      account_verified_at {DateTime.current}
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
