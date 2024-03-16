# frozen_string_literal: true

class CreateDevices < ActiveRecord::Migration[7.1]
  def change
    create_table :devices do |t|
      t.references :authenticable, polymorphic: true
      t.text :fcm_token
      t.integer :device_type, default: 0
      t.boolean :logged_out, default: true
      t.string :locale, default: "en"
      t.timestamps
    end
  end
end
