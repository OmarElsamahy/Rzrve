# frozen_string_literal: true

ActiveAdmin.register Venue do
  permit_params :city_id, :vendor_id, address_attributes: [:id,
                                                           :full_address,
                                                           :city_id,
                                                           :country_id,
                                                           :district,
                                                           :is_default,
                                                           :is_hidden,
                                                           :landmark,
                                                           :lat,
                                                           :long,
                                                           :lookup_key,
                                                           :name,
                                                           :street_information]

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
      f.input :vendor
      f.input :city
      f.inputs "Address" do
        f.semantic_fields_for :address, f.object.address || f.object.build_address do |address_fields|
          address_fields.input :country, include_blank: false, label: "Select Country"
          address_fields.input :city, include_blank: false, label: "Select City"
          address_fields.input :full_address, as: :string
          address_fields.input :district
          address_fields.input :is_default
          address_fields.input :is_hidden
          address_fields.input :landmark
          address_fields.input :lat
          address_fields.input :long
          address_fields.input :lookup_key
          address_fields.input :name
          address_fields.input :street_information
        end
      end
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
    panel "Address" do
      attributes_table_for venue.address do
        row :full_address
        row :city
        row :country
        row :district
        row :is_default
        row :is_hidden
        row :landmark
        row :lat
        row :long
        row :lookup_key
        row :name
        row :street_information
      end
    end
  end
end
