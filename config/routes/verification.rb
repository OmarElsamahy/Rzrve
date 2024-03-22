# frozen_string_literal: true

scope "/verification" do
  post ":verification_type/send_verification_info", to: "verification#send_verification_info"
  post ":verification_type/verify", to: "verification#verify"
end
