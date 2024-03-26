class CreateBookings < ActiveRecord::Migration[7.1]
  def change
    create_table :bookings do |t|
      t.belongs_to :court, null: false, foreign_key: true
      t.belongs_to :user, foreign_key: true
      t.datetime :start_time
      t.datetime :end_time
      t.timestamps
    end
  end
end
