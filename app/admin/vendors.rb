# frozen_string_literal: true

ActiveAdmin.register Vendor do
  permit_params :account_verified_at, :avatar, :country_code, :email,
                :password, :password_confirmation, :name, :phone_number,
                :profile_status, :status


  index do
    selectable_column
    id_column
    column :name
    column :email
    column :status
    column :profile_status
    column :country_code
    column :phone_number
    column :account_verified_at
    column :avatar
    column :created_at
    column :updated_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :email
      f.input :status
      f.input :profile_status
      f.input :avatar, as: :string
      f.input :country_code
      f.input :phone_number
      f.input :account_verified_at, as: :datepicker
      if f.object.new_record?
        f.input :password
        f.input :password_confirmation
      end
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :email
      row :status
      row :profile_status
      row :country_code
      row :phone_number
      row :account_verified_at
      row :created_at
      row :updated_at
    end
  end
end
