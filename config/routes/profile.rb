# frozen_string_literal: true

namespace :users do
  resource :profile, only: [:show, :destroy] do
    collection do
      put "", action: :update
      patch "", action: :patch_update
      patch "change_email", action: :change_email
    end
  end
end
