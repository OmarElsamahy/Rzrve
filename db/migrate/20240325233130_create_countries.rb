# frozen_string_literal: true

class CreateCountries < ActiveRecord::Migration[7.1]
  def change
    create_table :countries do |t|
      t.string :name
      t.string :iso_code
      t.string :lookup_key
      t.timestamps null: false
    end

    add_index :countries, :iso_code, unique: true
    add_index :countries, :lookup_key, unique: true
  end
end
