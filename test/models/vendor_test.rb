# frozen_string_literal: true

require "test_helper"

class VendorTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

# == Schema Information
#
# Table name: vendors
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
#  profile_status            :integer
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
#  index_vendors_on_account_verified_at                       (account_verified_at)
#  index_vendors_on_country_code_and_phone_number_and_status  (country_code,phone_number,status) UNIQUE WHERE (status = 0)
#  index_vendors_on_email                                     (email) UNIQUE WHERE ((status = 0) AND (email IS NOT NULL))
#  index_vendors_on_email_and_status                          (email,status) UNIQUE WHERE ((status = 0) AND (email_verified_at IS NOT NULL))
#  index_vendors_on_reset_password_token                      (reset_password_token) UNIQUE
#  index_vendors_on_status                                    (status)
#
