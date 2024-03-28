# frozen_string_literal: true

ActiveAdmin.register Country do
  permit_params :name, :iso_code, :lookup_key
end
