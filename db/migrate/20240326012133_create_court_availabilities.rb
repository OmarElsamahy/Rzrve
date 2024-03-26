class CreateCourtAvailabilities < ActiveRecord::Migration[7.1]
  def change
    create_table :court_availabilities do |t|
      t.belongs_to :court, null: false, foreign_key: true
      t.string :day_of_week
      t.time :start_time
      t.time :end_time
      t.timestamps
    end
  end
end
