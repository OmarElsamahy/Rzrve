# frozen_string_literal: true

module Api::V1::Lookups::LookupsSetters
  extend ActiveSupport::Concern

  def set_current_vendor
    @current_vendor = Vendor.find(params[:vendor_id])
  end

  def set_current_city
    @current_city = City.find(params[:city_id])
  end

  def set_current_country
    @current_country = Country.find(params[:country_id])
  end

end
