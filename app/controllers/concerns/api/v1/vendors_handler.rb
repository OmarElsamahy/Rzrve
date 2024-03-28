# frozen_string_literal: true

module Api::V1::VendorsHandler
  extend ActiveSupport::Concern

  private

  def index_vendors_in_city
    @vendors = paginate_collection(
      Vendor.accepted_profile_status
        .in_city(RequestStore[:current_city_id])
        .sort_and_order(sort_by: params[:sort_by], order: params[:sort_order])
    )
  end
end
