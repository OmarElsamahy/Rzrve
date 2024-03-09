# frozen_string_literal: true

resources :passwords, only: [] do
  collection do
    get "is_valid", action: :is_valid
    post ":user_type/check_exists", action: :check_exists
    post ":user_type/send_reset_password_info", action: :send_reset_password_info
    post ":user_type/verify_otp", action: :verify_otp
    post ":user_type/reset_password", action: :reset_password
    put "change_password", action: :change_password
  end
end
