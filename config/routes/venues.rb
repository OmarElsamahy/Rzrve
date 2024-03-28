# frozen_string_literal: true

resources :venues, only: [:show, :index], param: :venue_id
