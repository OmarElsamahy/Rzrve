# frozen_string_literal: true

module User::UserHelpers
  extend ActiveSupport::Concern

  def generate_code(code_size: 6)
    code = nil
    code = code_size.times.map { rand(10) }.join.to_s while code.nil? || self.class.where("verification_code = :code OR  reset_password_token = :code", code: code).present?
    code
  end

  def delete_existing_unverified_users
    if email.present?
      self.class.active.unverified.all_except(self).destroy_by("email = :email", email: email)
      self.class.email_verified.all_except(self).where(unconfirmed_email: email).update_all(unconfirmed_email: nil)
    end
    if phone_number_verified_at.present? && phone_number.present? && country_code.present?
      self.class.email_verified.all_except(self).where(unconfirmed_phone_number: phone_number,
        unconfirmed_country_code: country_code)
        .update_all(unconfirmed_phone_number: nil, unconfirmed_country_code: nil)
    end
  end

  def set_phone_number
    if (phone_number_changed? || country_code_changed?) && phone_number.present? && country_code.present?
      phone_obj = PhoneFormatter.format_phone(phone_number, country_code)
      unless phone_obj.nil?
        self.country_code = phone_obj[:country_code]
        self.phone_number = phone_obj[:phone]
      end
    end

    if (unconfirmed_phone_number_changed? || unconfirmed_country_code_changed?) && unconfirmed_phone_number.present? && unconfirmed_country_code.present?
      phone_obj = PhoneFormatter.format_phone(unconfirmed_phone_number, unconfirmed_country_code)
      unless phone_obj.nil?
        self.unconfirmed_country_code = phone_obj[:country_code]
        self.unconfirmed_phone_number = phone_obj[:phone]
      end
    end

    nullify_reduntant_unconfirmed_phone_number
  end

  def set_account_verified_at
    self.account_verified_at = DateTime.now
  end

  def is_verified?
    email_verified_at.present? || phone_number_verified_at.present?
  end

  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end
end
