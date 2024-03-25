# frozen_string_literal: true

class CreateCountry < ActiveRecord::Migration[7.1]
  def change
    create_table :countries do |t|
      t.string :name
      t.string :iso_code, unique: true
      t.string :lookup_key, unique: true
      t.timestamps
    end
  end
end
