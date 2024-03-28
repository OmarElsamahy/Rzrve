# frozen_string_literal: true

ActiveAdmin.register Venue do
  permit_params :city_id, :vendor_id

  index do
    selectable_column
    id_column
    column :city
    column :vendor
    column :created_at
    column :updated_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :city
      f.input :vendor
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :city
      row :vendor
      row :created_at
      row :updated_at
    end
  end
end
