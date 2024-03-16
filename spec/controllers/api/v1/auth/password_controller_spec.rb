# frozen_string_literal: true

require "rails_helper"

RSpec.describe Api::V1::Auth::PasswordsController, type: :controller do
  let(:user) { create(:user) }
  let(:token) { create_token(user) }

  before { request.headers["Authorization"] = "Bearer #{token}" }
  before(:each) do
    @reset_password_token = nil
    @token_after_otp_verification = nil
  end

  describe "POST #is_valid" do
    it "returns a successful response with correct password" do
      post :is_valid, params: {password: "Testtest1@"}
      expect(response).to have_http_status(:ok)
    end

    it "returns UnprocessableEntity with incorrect password" do
      post :is_valid, params: {password: "IncorrectPassword"}
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "POST #change_password" do
    context "with valid parameters" do
      it "returns a successful response and changes the password" do
        post :change_password, params: {
          user: {
            current_password: "Testtest1@",
            password: "NewPassword123@",
            password_confirmation: "NewPassword123@"
          }
        }
        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid current password" do
      it "returns UnprocessableEntity" do
        post :change_password, params: {
          user: {
            current_password: "InvalidPassword",
            password: "NewPassword123@",
            password_confirmation: "NewPassword123@"
          }
        }
        expect(response).to have_http_status(:bad_request)
      end
    end

    context "with mismatched password confirmation" do
      it "returns UnprocessableEntity" do
        post :change_password, params: {
          user: {
            current_password: "Testtest1@",
            password: "NewPassword123@",
            password_confirmation: "MismatchedPassword"
          }
        }
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe "Password reset flow" do
    let(:existing_user) { create(:user, email: "omarelsamahy@gmail.com", status: :active) }
    let(:device_params) { {device_type: "android", fcm_token: "test_fcm_token"} }

    describe "POST #send_reset_password_info" do
      context "with valid parameters" do
        it "returns a successful response and sends reset password info" do
          post :send_reset_password_info, params: {user: {email: existing_user.email}, user_type: "user"}
          expect(response).to have_http_status(:ok)
          json_response = JSON.parse(response.body)
          expect(json_response["data"]["reset_password_token"]).to be_present unless Rails.env.production?
        end
      end
      context "with invalid email" do
        it "returns NotFound error" do
          post :send_reset_password_info, params: {user: {email: "nonexistent@example.com"}, user_type: "user"}
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    describe "POST #verify_otp" do
      context "with valid verification code" do
        it "returns a successful response and verifies OTP" do
          post :verify_otp, params: {
            user: {email: existing_user.email},
            verification_code: create_reset_password_token(existing_user),
            user_type: "user"
          }
          expect(response).to have_http_status(:ok)
          json_response = JSON.parse(response.body)
          expect(json_response["data"]["token"]).to be_present
        end
      end

      context "with invalid verification code" do
        it "returns UnprocessableEntity" do
          post :verify_otp, params: {
            user: {email: existing_user.email},
            verification_code: "invalid_code",
            user_type: "user"
          }
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end

    describe "POST #reset_password" do
      before(:each) do
        request.headers["verification-token"] = create_verification_token(existing_user)
      end
      context "with valid parameters" do
        it "returns a successful response and resets the password" do
          post :reset_password, params: {
            user: {
              email: existing_user.email,
              password: "NewPassword123@",
              password_confirmation: "NewPassword123@"
            },
            device: device_params,
            user_type: "user"
          }
          expect(response).to have_http_status(:ok)
          json_response = JSON.parse(response.body)
          expect(json_response["data"]["user"]).to be_present
        end
      end

      context "with mismatched password confirmation" do
        it "returns UnprocessableEntity" do
          post :reset_password, params: {
            user: {
              email: existing_user.email,
              password: "NewPassword123@",
              password_confirmation: "MismatchedPassword"
            },
            device: device_params,
            user_type: "user"
          }
          expect(response).to have_http_status(:bad_request)
        end
      end
    end
  end

  def create_reset_password_token(user)
    user.send_reset_password_email
    user.reset_password_token
  end

  def create_verification_token(user)
    otp = create_reset_password_token(user)
    User::OtpService.new(user: user, code_scope: "reset_password", otp: otp).verify_otp
  end
end
