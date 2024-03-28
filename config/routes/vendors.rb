# frozen_string_literal: true
resources :vendors, only: [:index, :show], param: :vendor_id
