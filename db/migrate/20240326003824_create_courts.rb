# frozen_string_literal: true

class CreateCourts < ActiveRecord::Migration[7.1]
  def change
    create_table :courts do |t|
      t.belongs_to :venue, null: false, foreign_key: true
      t.string :name
      t.timestamps
    end
  end
end
