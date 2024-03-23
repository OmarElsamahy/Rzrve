class DeviseCreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      ## Database authenticatable
      t.string :email
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string :reset_password_token
      t.datetime :reset_password_sent_at
      t.string :verification_code
      t.datetime :verification_code_sent_at

      ## Trackable
      t.integer :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string :current_sign_in_ip
      t.string :last_sign_in_ip

      ## Confirmable
      # t.string   :confirmation_token
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      t.string :unconfirmed_email # Only if using reconfirmable
      t.string :unconfirmed_country_code
      t.string :unconfirmed_phone_number
      t.timestamp :phone_number_verified_at
      t.timestamp :email_verified_at
      t.timestamp :account_verified_at

      ## Profile
      t.string :name
      t.integer :status
      t.string :country_code
      t.string :phone_number
      t.text :avatar

      t.timestamps null: false
    end

    # Indexes
    add_index :users, :email, unique: true, where: "status = 0 AND email IS NOT NULL"
    add_index :users, :reset_password_token, unique: true
    add_index :users, :status
    add_index :users, [:email, :status], unique: true, where: "status = 0 AND email_verified_at IS NOT NULL"
    add_index :users, [:country_code, :phone_number, :status], unique: true, where: "status = 0"
    add_index :users, :account_verified_at
  end
end
