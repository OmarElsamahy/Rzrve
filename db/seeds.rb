# frozen_string_literal: true
# ServerSentry.find_or_create_by(email: "omarelsamahy109@gmail.com", environment: :any)
AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?
