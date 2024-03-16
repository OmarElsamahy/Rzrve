# frozen_string_literal: true

module Api::V1::Lookups::LookupsSetters
  extend ActiveSupport::Concern

  private

  def set_current_expert_request_question
    @expert_request_question = ExpertRequestQuestion.find(params[:expert_request_question_id])
  end

  def set_current_expert_request_general_question
    @expert_request_general_question = ExpertRequestGeneralQuestion.find(params[:expert_request_general_question_id])
  end

  def set_current_expert_request_question_option
    @expert_request_question_option = ExpertRequestQuestionOption.find(params[:expert_request_question_option_id])
  end

  def set_current_currency
    @currency = Currency.find(params[:currency_id])
  end

  def set_current_country
    @country = Country.find(params[:country_id])
  end

  def set_current_city
    @city = City.find(params[:city_id])
  end

  def set_current_onboarding
    @onboarding = Onboarding.find(params[:onboarding_id])
  end

  def set_current_journey
    @journey = Journey.find(params[:journey_id])
  end

  def set_current_main_category
    @main_category = MainCategory.find(params[:main_category_id])
  end

  def set_current_sub_category
    puts "params[:sub_category_id]: #{params[:sub_category_id]}"
    @sub_category = SubCategory.find(params[:sub_category_id])
  end

  def set_current_system_configuration
    @system_configuration = SystemConfiguration.find(params[:system_configuration_id])
  end

  def set_current_language
    @language = Language.find(params[:language_id])
  end

  def set_current_reservation
    @reservation = Reservation.find(params[:reservation_id])
  end

  def set_current_transaction
    @transaction = PaymentTransaction.find(params[:transaction_id])
  end

  def set_current_post
    @post = Post.find(params[:post_id])
  end

  def set_current_published_post
    @post = Post.published_status.find(params[:post_id])
  end

  def set_current_comment
    @comment = Comment.find_by!(id: params[:comment_id], post_id: params[:post_id])
  end

  def set_current_report_reason
    @report_reason = ReportReason.find(params[:report_reason_id])
  end

  def set_current_social_medium
    @social_medium = SocialMedium.find(params[:social_medium_id])
  end

  def set_current_document
    @document = Document.find(params[:document_id])
  end

  def set_current_account_verification_request
    @account_verification_request = AccountVerificationRequest.find(params[:account_verification_request_id])
  end

  def set_current_equipment
    @equipment = Equipment.find(params[:equipment_id])
  end

  def set_current_money_transfer_request
    @money_transfer_request = MoneyTransferRequest.find(params[:money_transfer_request_id])
  end

  def set_current_journey_cancellation_reason
    @journey_cancellation_reason = JourneyCancellationReason.find(params[:journey_cancellation_reason_id])
  end

  def set_current_contact
    @contact = Contact.find(params[:contact_id])
  end
end
