# frozen_string_literal: true

module User::UserVerificationHelper
  extend ActiveSupport::Concern

  def generate_verification_code
    code = generate_code(code_size: 6)
    self.verification_code = code
    self.verification_code_sent_at = DateTime.now + 15.seconds
  end

  def email_to_verify
    return unconfirmed_email if unconfirmed_email.present?
    email
  end

  def phone_number_to_verify
    return unconfirmed_country_code, unconfirmed_phone_number if unconfirmed_country_code.present? && unconfirmed_phone_number.present?
    [country_code, phone_number]
  end

  def send_email_verification_mail
    generate_verification_code
    VerificationMailer.with(user: self, verification_code: verification_code, email: email_to_verify).email_verification.deliver_later
    save!
  end

  def send_phone_verification_sms
    self.enforce_phone_verification_sms_callback = false if user?
    generate_verification_code
    # TODO send sms
    save!
  end

  def nullify_reduntant_unconfirmed_phone_number
    if unconfirmed_country_code == country_code && unconfirmed_phone_number == phone_number
      self.unconfirmed_country_code = nil
      self.unconfirmed_phone_number = nil
    end
  end

  def valid_unconfirmed_phone_number
    errors.add(:phone_number, :taken) if self.class.phone_number_verified.where(country_code: unconfirmed_country_code, phone_number: unconfirmed_phone_number).exists?
  end

  def verify_email!
    update_column(:email_verified_at, DateTime.now) if email_verified_at.nil?
  end

  def verify_phone_number!
    update_column(:phone_number_verified_at, DateTime.now) if phone_number_verified_at.nil?
  end

  def email_verified?
    email_verified_at.present?
  end

  def phone_number_verified?
    phone_number_verified_at.present?
  end

  def account_verified?
    account_verified_at?
  end

  def account_verification
    {
      verified: account_verified?,
      type: account_verification_type,
      display_color: User::ACCOUNT_VERIFICATION_COLORS[account_verification_type&.to_sym]
    }
  end
end
