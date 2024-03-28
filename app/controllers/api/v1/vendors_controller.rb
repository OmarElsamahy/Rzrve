# frozen_string_literal: true

class Api::V1::VendorsController < BaseApiController
  include Api::V1::VendorsHandler

  before_action :set_current_vendor, only: :show

  def index
    index_vendors_in_city
    render_response(status: :ok, data: { vendors: @vendors.as_json })
  end

  def show
    render_response(status: :ok, data: { vendor: @current_vendor.as_json(options: serializer_options(full_details: true)) })
  end

end
