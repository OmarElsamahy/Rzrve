# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :vendors
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", :as => :rails_health_check
  if Rails.env.development?
    get "/dev/tests/coverage", to: redirect("/dev/tests/coverage/index.html")
    mount Rack::Directory.new("coverage/") => "/dev/tests/coverage", :index => "index.html"
  end

  namespace :api do
    draw :v1
  end
end
