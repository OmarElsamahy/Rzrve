# frozen_string_literal: true

scope "/:user_type" do
  post "login", to: "sessions#create"
end
patch "verify_token_authenticity", to: "sessions#verify_token_authenticity"
delete "logout", to: "sessions#destroy"
