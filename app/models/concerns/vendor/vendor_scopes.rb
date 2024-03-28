# frozen_string_literal: true

module Vendor::VendorScopes
  extend ActiveSupport::Concern

  included do
    enable_attribute_scopes

    scope :active, -> { where(status: :active) }
    scope :available_for_login, -> { where(status: [:active, :suspended]) }
    scope :all_except, ->(users) { where.not(id: users) }
    scope :email_unverified, -> { where(email_verified_at: nil) }
    scope :phone_number_unverified, -> { where(phone_number_verified_at: nil) }
    scope :phone_number_verified, -> { where.not(phone_number_verified_at: nil) }
    scope :email_verified, -> { where.not(email_verified_at: nil) }
    scope :verified, -> { where.not(account_verified_at: nil) }
    scope :unverified, -> { where(account_verified_at: nil) }
    scope :search_by_name, ->(keyword) { where("lower(name) ILIKE :keyword", keyword: "%#{keyword}%") if keyword.present? }
    scope :filter_by_status, ->(status) { where(status: status) if status.present? }
    scope :visible_for, ->(user) {
            (user.present? && user.admin?) ? all : active
          }
    scope :in_city, ->(city_id) { joins(venues: :city).where(city: { id: city_id }) if city_id.present? }
  end
end
