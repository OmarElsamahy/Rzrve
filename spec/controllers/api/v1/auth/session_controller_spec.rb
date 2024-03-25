# frozen_string_literal: true

require "rails_helper"

RSpec.describe Api::V1::Auth::SessionsController, type: :controller do
  let(:user) { create(:user, :verified) }
  let(:device) { create(:device, authenticable: user) }
  before do
    @request.headers["Authorization"] = "Bearer #{user.get_token(device.id)}"
  end
  describe "POST #create" do
    context "with valid params" do
      it "creates a new session" do
        post :create, params: {user_type: "user",
                               user: {phone_number: user.phone_number,
                                      country_code: user.country_code,
                                      password: user.password},
                               device: {fcm_token: device.fcm_token, device_type: device.device_type}}
        expect(response).to have_http_status(:created)
        expect(response.body).to include(user.phone_number)
        token = JSON.parse(response.body)["data"]["extra"]["access_token"]
        decoded_token = JsonWebToken.decode(token)
        expect(decoded_token[:authenticable_id]).to eq(user.id)
        expect(decoded_token[:device]).to eq(device.id)
      end
    end

    context "with invalid params" do
      it "returns an error message" do
        post :create, params: {user_type: "user", user: {email: "invalid_email@example.com", password: "invalid_password"}, device: {fcm_token: device.fcm_token, device_type: device.device_type}}
        expect(response).to have_http_status(:not_found)
        expect(response.body).to include("Account Not Found")
      end
    end
  end

  describe "DELETE #destroy" do
    context "when user is logged in" do
      it "logs out the user" do
        delete :destroy
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Logged Out Successfully")
      end
    end
  end

  describe "GET #verify_token_authenticity" do
    context "with a valid token" do
      it "returns success" do
        get :verify_token_authenticity
        expect(response).to have_http_status(:no_content)
      end
    end

    context "with an invalid token" do
      it "returns an error message" do
        request.headers["Authorization"] = "Bearer invalid_token"
        get :verify_token_authenticity
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Invalid Token")
      end
    end
  end
end
