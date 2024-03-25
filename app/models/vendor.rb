# frozen_string_literal: true

class Vendor < ApplicationRecord
  include User::UserHelpers
  include User::UserScopes
  include User::ResetPasswordHelper
  include User::AuthenticationHelper
  include User::UserVerificationHelper
  include User::UserTypeHelper

  devise :database_authenticatable, :recoverable, :rememberable, :trackable

  attr_accessor :enforce_phone_verification_sms_callback

  enum :status, {active: 0, deactivated: 1, deleted: 2, suspended: 3}, suffix: :status, default: :active, validate: true
  enum :profile_status, {pending: 0, accepted: 1, declined: 2}, suffix: :profile_status, default: :pending, validate: true

  has_many :devices, as: :authenticable, dependent: :destroy

  validates :email,
    allow_blank: true,
    uniqueness: {conditions: -> { where.not(status: :deleted) }, if: :active_status?},
    format: {with: EMAIL_REGEX, if: -> { active_status? && email.present? }}

  validates :password, presence: {if: :password_required?},
    length: {within: PASSWORD_LENGTH, allow_blank: true},
    format: {with: PASSWORD_REGEX, allow_blank: true, message: I18n.t("errors.invalid_password")}
  validates_confirmation_of :password, if: :password_required?

  validates :phone_number,
    uniqueness: {scope: :country_code, conditions: -> { where(status: :active) }, if: :active_status?},
    presence: true
  validates :country_code, presence: true
  validate :valid_unconfirmed_phone_number, if: -> {
                                                  unconfirmed_country_code.present? && unconfirmed_phone_number.present? &&
                                                    (unconfirmed_country_code_changed? || unconfirmed_phone_number_changed?)
                                                }
  before_validation :set_phone_number, if: -> {
                                             active_status? &&
                                               ((unconfirmed_phone_number_changed? || unconfirmed_country_code_changed?) ||
                                                (phone_number_changed? || country_code_changed?))
                                           }
  before_validation :delete_existing_unverified_users, if: -> { (phone_number_changed? || country_code_changed? || email_changed?) && active_status? }

  before_save :set_account_verified_at, if: -> { email_verified_at_changed? || phone_number_verified_at_changed? }

  after_create :send_email_verification_mail, if: -> { email.present? && !email_verified? && active_status? }
  after_save :send_email_verification_mail, if: -> { saved_change_to_unconfirmed_email? && !email_verified? && active_status? }
  after_save :send_phone_verification_sms, if: -> {
                                                 (saved_change_to_unconfirmed_country_code? || saved_change_to_unconfirmed_phone_number? ||
                                                  enforce_phone_verification_sms_callback) &&
                                                   unconfirmed_country_code.present? && unconfirmed_phone_number.present? && active_status?
                                               }
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
