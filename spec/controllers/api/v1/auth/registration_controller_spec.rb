# frozen_string_literal: true

require "rails_helper"

RSpec.describe Api::V1::Auth::RegistrationController, type: :controller do
  def create_params(email, password, name = "Test Name")
    {
      company: {
        name: name,
        email: email
      },
      user: {
        name: "name",
        password: password,
        password_confirmation: password,
        avatar: ""
      },
      device: {
        device_type: "android",
        fcm_token: "dummy_token"
      }
    }
  end

  describe "#create" do
    it "creates company and associates manager" do
      post :create, params: create_params("testing_email@gmail.com", "Testtest1@", "Test Name")

      expect(response).to have_http_status(:created)

      created_company = Company.find_by(name: "Test Name")
      expect(created_company).to be_present

      expect(created_company.manager).to be_present

      manager = Employee.find_by(email: "testing_email@gmail.com")

      expect(created_company.manager).to eq(manager)
    end

    it "creates company and manager with correct email and password" do
      post :create, params: create_params("testing_email@gmail.com", "Testtest1@", "Test Name")

      expect(response).to have_http_status(:created)

      response_data = JSON.parse(response.body)["data"]
      manager_id = response_data["manager"]["id"]

      manager = Employee.find(manager_id)
      expect(manager).to be_present
      expect(manager.email).to eq("testing_email@gmail.com")
      expect(manager.valid_password?("Testtest1@")).to be true
    end

    it "returns 422 if email is not provided" do
      post :create, params: create_params(nil, "Testtest1@", "Test Name")

      expect(response).to have_http_status(422)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response["error"]).to eq("VALIDATION_FAILED")
    end

    it "returns 422 if password is not provided" do
      post :create, params: create_params("testing_email@gmail.com", nil, "Test Name")

      expect(response).to have_http_status(422)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response["error"]).to eq("VALIDATION_FAILED")
    end
  end
end
