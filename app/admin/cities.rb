# frozen_string_literal: true

ActiveAdmin.register City do
  permit_params :name, :country_id, :lookup_key
end
