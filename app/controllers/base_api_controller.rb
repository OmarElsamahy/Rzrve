# frozen_string_literal: true

class BaseApiController < ApplicationController
  include Api::V1::Lookups::LookupsSetters
  include ResponseHelper
  include ExceptionHandler::RescueFrom
  include JsonWebToken
  include ParamsHelper
  include Authorization

  skip_before_action :verify_authenticity_token
  before_action :set_time_zone
  around_action :use_time_zone
  before_action :validate_request_format
  before_action :authorize_request
  before_action :authorize_action!
  before_action :check_verified
  before_action :set_paging_parameters

  private

  def validate_and_limit(value, min, max)
    [value, min].max
      .then { |v| max.nil? ? v : [v, max].min }
  end

  def set_paging_parameters
    @page = validate_and_limit(params[:page_number]&.to_i || 1, 1, nil)
    @per_page = validate_and_limit(params[:page_size]&.to_i || 10, 1, MAX_PAGE_SIZE)
  end

  def paginate_collection(collection, skip_pagination_info: false, page: @page, per_page: @per_page)
    unless skip_pagination_info
      total_count = collection.reorder(nil).size
      total_count = total_count.is_a?(Hash) ? total_count.count : total_count
      @pagination_info = {total_count: total_count, page_number: page, page_size: per_page}
    end
    collection.loaded? ?
             Kaminari.paginate_array(collection).page(page).per(per_page) : collection.page(page).per(per_page)
  end

  def set_time_zone
    @time_zone = if request.headers["Timezone"].present? && ActiveSupport::TimeZone[request.headers["Timezone"].to_s].present?
      request.headers["Timezone"].to_s
    else
      "UTC"
    end
  end

  def use_time_zone(&)
    Time.use_zone(@time_zone, &)
  end

  attr_reader :current_user

  def current_ability
    controller_name_segments = params[:controller].split("/")
    controller_last_segment = controller_name_segments.pop
    controller_namespace = controller_name_segments.join("/").camelize
    @current_ability ||= Ability.new(current_user, controller_namespace, controller_last_segment)
  end

  def downcase_email_params
    if params[:user].present? && !params[:user][:email].blank?
      params[:user][:email] = params[:user][:email].downcase.strip
    end
  end

  def validate_request_format
    request.format = :json if request.format.html? # default to json
    raise ActionController::UnknownFormat unless request.format.json? || request.format.xml? || request.format == Mime::ALL
  end

  def logger
    @logger ||= ConsoleLogger.instance.logger
  end
end
