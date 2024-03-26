class CreateMedia < ActiveRecord::Migration[7.1]
  def change
    create_table :media do |t|
      t.references :mediable, polymorphic: true
      t.integer :media_type, default: 0
      t.string :file_name
      t.text :url
      t.timestamps
    end
  end
end
