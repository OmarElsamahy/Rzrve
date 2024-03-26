# frozen_string_literal: true

class Booking < ApplicationRecord

  scope :by_user, ->(user_id) { where(user_id: user_id) }
  scope :overlapping, ->(start_time, end_time) { where('(start_time BETWEEN ? AND ?) OR (end_time BETWEEN ? AND ?)', start_time, end_time, start_time, end_time) }

  validates :start_time, :end_time, presence: true

  belongs_to :court
  belongs_to :user

end

# == Schema Information
#
# Table name: bookings
#
#  id         :bigint           not null, primary key
#  end_time   :datetime
#  start_time :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  court_id   :bigint           not null
#  user_id    :bigint
#
# Indexes
#
#  index_bookings_on_court_id  (court_id)
#  index_bookings_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (court_id => courts.id)
#  fk_rails_...  (user_id => users.id)
#
