# frozen_string_literal: true

Rails.application.configure do
  config.after_initialize do
    Rails.application.routes.append do
      match "*path", to: "routing_error#routing_error", via: :all
    end
  end
end
