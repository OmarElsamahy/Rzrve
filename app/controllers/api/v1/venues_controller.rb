# frozen_string_literal: true

class Api::V1::VenuesController < BaseApiController
  include Api::V1::VenuesHandler

  before_action :set_current_venue, only: :show

  def index
    index_venues_in_city
    render_response(status: :ok, data: { venues: @venues.as_json })
  end

  def show
    render_response(status: :ok, data: { venue: @current_venue.as_json(options: serializer_options(full_details: true)) })
  end

end
