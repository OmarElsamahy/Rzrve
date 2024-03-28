# frozen_string_literal: true

namespace :v1 do
  draw :auth
  draw :profile
  draw :vendors
  resources :cities, only: [:index, :show], param: :city_id
  resources :countries, only: [:index, :show], param: :country_id
end
