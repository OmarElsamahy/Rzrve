class CreateVenues < ActiveRecord::Migration[7.1]
  def change
    create_table :venues do |t|
      t.references :vendor, index: true, foreign_key: true
      t.references :city, index: true, foreign_key: true
      t.timestamps
    end
  end
end
