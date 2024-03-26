# frozen_string_literal: true

class Court < ApplicationRecord
  scope :by_venue, ->(venue_id) { where(venue_id: venue_id) }

  validates :name, presence: true

  belongs_to :venue
  has_many :media, as: :mediable, dependent: :destroy

  after_create :create_default_court_availabilities

  private

  def create_default_court_availabilities
    Date::DAYNAMES.each do |day|
      CourtAvailability.create!(
        court: self,
        day_of_week: day,
        start_time: Time.zone.parse('12:00 PM'),
        end_time: Time.zone.parse('12:00 AM')
      )
    end
  end

end

# == Schema Information
#
# Table name: courts
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  venue_id   :bigint           not null
#
# Indexes
#
#  index_courts_on_venue_id  (venue_id)
#
# Foreign Keys
#
#  fk_rails_...  (venue_id => venues.id)
#
