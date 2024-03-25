# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  include GeneralHelper

  scope :sort_and_order, ->(sort_by: "id", order: "desc") {
                           valid_sort_columns = column_names
                           valid_orders = %w[asc desc]

                           sort_by = valid_sort_columns.include?(sort_by) ? sort_by : "id"
                           order = valid_orders.include?(order&.downcase) ? order.downcase : "desc"

                           order("#{sort_by} #{order}")
                         }

  class << self
    private

    def enable_attribute_scopes
      attribute_names.each do |attr|
        scope("filter_by_#{attr}", ->(value) { where(attr => value) unless value.nil? }) unless respond_to?(attr, true)
      end
    end
  end
end
