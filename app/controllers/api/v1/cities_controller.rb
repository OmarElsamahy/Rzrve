# frozen_string_literal: true

class Api::V1::CitiesController < BaseApiController

  skip_before_action :authorize_request, :authorize_action!
  before_action :set_current_city, only: :show

  def index
    @cities = City.filter_by_country(params[:country_id])
    render_response(status: :ok, data: { cities: paginate_collection(@cities).as_json })
  end

  def show
    render_response(status: :ok, data: { city: @current_city.as_json(options: serializer_options(full_details: true)) })
  end

end
