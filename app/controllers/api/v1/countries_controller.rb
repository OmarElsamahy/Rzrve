# frozen_string_literal: true

class Api::V1::CountriesController < BaseApiController

  skip_before_action :authorize_request, :authorize_action!
  before_action :set_current_country, only: :show

  def index
    @countries = Country.all.load_async
    render_response(status: :ok, data: { countries: paginate_collection(@countries).as_json })
  end

  def show
    render_response(status: :ok, data: { country: @current_country.as_json(options: serializer_options(full_details: true)) })
  end

end
