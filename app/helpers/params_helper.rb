# frozen_string_literal: true

module ParamsHelper
  def set_localized_params(base_params: {}, permitted_attributes: [])
    permitted_attributes = [permitted_attributes] unless permitted_attributes.is_a?(Array)
    result = {}
    return result if base_params.blank? || permitted_attributes.blank?

    AVAILABLE_LOCALES.each do |locale|
      next if base_params[locale].blank?
      base_params[locale].each do |attr, value|
        result[:"#{attr}_#{locale}"] = value if permitted_attributes.include?(attr.to_sym)
      end
    end

    result
  end

end
