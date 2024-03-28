# frozen_string_literal: true

module Api::V1::VenuesHandler
  extend ActiveSupport::Concern

  private

  def index_venues_in_city
    @venues = paginate_collection(
      Venue.filter_by_vendor(params[:vendor_ids])
        .in_city(RequestStore[:current_city_id])
        .sort_and_order(sort_by: params[:sort_by], order: params[:sort_order])
    )
  end
end
