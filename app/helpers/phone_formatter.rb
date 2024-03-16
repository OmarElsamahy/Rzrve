# frozen_string_literal: true

module PhoneFormatter
  def self.format_phone(full_phone, user_country_code)
    key = user_country_code.to_s.sub("+", "")
    location = COUNTRIES_DICT[key]
    raise ExceptionHandler::BadRequest.new(error: "invalid_country_code") unless location.present?
    puts "Checking #{full_phone} with country code #{key} in #{location}"
    number = GlobalPhone.parse(full_phone, location)
    if number.present?
      {country_code: number.country_code.to_s, phone: number.national_string}
    else
      raise ExceptionHandler::BadRequest.new(error: "invalid_phone_number")
    end
  rescue
    raise ExceptionHandler::BadRequest.new(error: "invalid_phone_number")
  end
end
