# frozen_string_literal: true

class User::VerificationService
  def initialize(user: nil, verification_type: "email", service: "")
    @user = user
    @service = service
    @verification_type = verification_type
  end

  def verify(token)
    email_to_verify = @user.email_to_verify
    counter_code_to_verify, phone_number_to_verify = @user.phone_number_to_verify
    update_hash, extra_data = User::TokenVerification.new(
      user: @user,
      token: token,
      verification_type: @verification_type,
      verification_email: email_to_verify,
      verification_country_code: counter_code_to_verify,
      verification_phone_number: phone_number_to_verify,
      code_scope: "verification"
    ).verify_token
    @user.assign_attributes(update_hash.merge(verification_data).merge(extra_data))
    @user
  end

  def verification_data
    to_set = {
      verification_code_sent_at: nil,
      verification_code: nil
    }
    case @verification_type
    when "email"
      to_merge = email_attributes_to_set
    when "phone_number"
      to_merge = phone_number_attributes_to_set
    end
    to_set.merge(to_merge)
  end

  def phone_number_attributes_to_set
    to_set = {}
    country_code_to_verify, phone_number_to_verify = @user.phone_number_to_verify
    if (country_code_to_verify != @user.country_code) || (phone_number_to_verify != @user.phone_number)
      to_set.merge!({
        country_code: @user.unconfirmed_country_code,
        phone_number: @user.unconfirmed_phone_number,
        unconfirmed_country_code: nil,
        unconfirmed_phone_number: nil
      })
    end
    to_set
  end

  def email_attributes_to_set
    to_set = {}
    unless @user.email.blank?
      email_to_verify = @user.email_to_verify
      if email_to_verify != @user.email
        to_set[:email] = @user.unconfirmed_email
        to_set[:unconfirmed_email] = nil
      end
    end
    to_set
  end
end
