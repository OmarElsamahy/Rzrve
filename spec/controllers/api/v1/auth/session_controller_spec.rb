# frozen_string_literal: true

require "rails_helper"

RSpec.describe Api::V1::Auth::SessionsController, type: :controller do
  describe "POST #create" do
    let(:user) { create(:employee, email: "testing_email@gmail.com", password: "Testtest1@") }
    let(:device_params) { attributes_for(:device, device_type: "android", fcm_token: "test") }

    it "logs in successfully and returns access token" do
      post :create, params: {user_type: "employee", user: {email: user.email, password: "Testtest1@"}, device: device_params}

      expect(response).to have_http_status(:created)

      json_response = JSON.parse(response.body)
      expect(json_response["message"]).to eq("Successful")
      expect(json_response["data"]["user"]["status"]).to eq("active")
      expect(json_response["data"]["extra"]["access_token"]).to be_present
    end

    it "fails to log in with wrong password" do
      post :create, params: {user_type: "employee", user: {email: user.email, password: "wrong_password"}, device: device_params}

      expect(response).to have_http_status(:unauthorized)

      json_response = JSON.parse(response.body)
      expect(json_response["error"]).to eq("invalid_credentials")
      expect(json_response["message"]).to eq("Invalid Credentials")
    end

    it "fails to log in with wrong email" do
      post :create, params: {user_type: "employee", user: {email: "wrong_email@example.com", password: "Testtest1@"}, device: device_params}

      expect(response).to have_http_status(:not_found)

      json_response = JSON.parse(response.body)
      expect(json_response["error"]).to eq("account_not_found")
      expect(json_response["message"]).to eq("Account Not Found")
    end
  end
end

RSpec.describe Api::V1::Auth::SessionsController, type: :controller do
  describe "DELETE #destroy" do
    let(:user) { create(:employee) }
    let(:device) { create(:device, authenticable: user) }

    before do
      @request.headers["Authorization"] = "Bearer #{user.get_token(device.id)}"
    end

    it "logs out successfully and destroys the user device" do
      delete :destroy

      expect(response).to have_http_status(:ok)

      json_response = JSON.parse(response.body)
      expect(json_response["message"]).to eq("Logged Out Successfully")
      expect(Device.exists?(device.id)).to be_falsey
    end
  end
end
