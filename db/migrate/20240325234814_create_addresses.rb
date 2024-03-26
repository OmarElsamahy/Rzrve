class CreateAddresses < ActiveRecord::Migration[7.1]
  def change
    create_table :addresses do |t|
      t.string :name
      t.string :lookup_key
      t.string :lat
      t.string :long
      t.text :full_address
      t.string :district
      t.string :street_information
      t.string :landmark
      t.boolean :is_hidden
      t.boolean :is_default

      t.references :country
      t.references :city
      t.references :addressable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
