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

  def registration_params
    params.require(:user).permit(:country_code, :phone_number, :avatar, :password, :email, :name, :password_confirmation)
  end

  def user_profile_params
    params.require(:user).permit(:name, :avatar, :country_code, :phone_number)
  end

  def device_params
    params.require(:device).permit(:fcm_token, :device_type)
  end
end
