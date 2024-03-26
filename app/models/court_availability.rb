# frozen_string_literal: true

class CourtAvailability < ApplicationRecord
  scope :by_court, ->(court_id) { where(court_id: court_id) }
  scope :by_day_of_week, ->(day_of_week) { where(day_of_week: day_of_week) }

  validates :day_of_week, :start_time, :end_time, presence: true
  validates :day_of_week, uniqueness: { scope: :court_id }
  validate :end_time_after_start_time
  validate :valid_day_of_week

  belongs_to :court

  private

  def valid_day_of_week
    unless Date::DAYNAMES.include?(day_of_week)
      errors.add(:day_of_week, I18n.t("incorrect_day"))
    end
  end

  def end_time_after_start_time
    return unless start_time && end_time

    errors.add(:end_time, "must be after start time") if start_time >= end_time
  end
end

# == Schema Information
#
# Table name: court_availabilities
#
#  id          :bigint           not null, primary key
#  day_of_week :string
#  end_time    :time
#  start_time  :time
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  court_id    :bigint           not null
#
# Indexes
#
#  index_court_availabilities_on_court_id  (court_id)
#
# Foreign Keys
#
#  fk_rails_...  (court_id => courts.id)
#
