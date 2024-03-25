# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Auth::RegistrationController, type: :controller do
  describe 'POST #create' do
    context 'with valid params' do
      let(:valid_params) do
        {
          user: {
            country_code: '1',
            phone_number: '1234567890',
            avatar: 'avatar_url',
            password: 'password123',
            email: 'test@example.com',
            name: 'Test User',
            password_confirmation: 'password123'
          },
          device: {
            fcm_token: 'fcm_token',
            device_type: :android
          }
        }
      end

      it 'creates a new user and device' do
        expect {
          post :create, params: valid_params
        }.to change(User, :count).by(1)
         .and change(Device, :count).by(1)

        expect(response).to have_http_status(:created)

        user = User.last
        device = Device.last

        expect(user.country_code).to eq(valid_params[:user][:country_code])
        expect(user.phone_number).to eq(valid_params[:user][:phone_number])
        expect(user.avatar).to eq(valid_params[:user][:avatar])
        # Add more expectations for other user attributes

        expect(device.fcm_token).to eq(valid_params[:device][:fcm_token])
        expect(device.device_type).to eq(valid_params[:device][:device_type].to_s)
        # Add more expectations for other device attributes
      end
      it 'returns the expected response body' do
        post :create, params: valid_params
        expect(response).to have_http_status(:created)

        user = User.last
        device = Device.last

        expected_body = expected_response_body(user, device)
        actual_body = JSON.parse(response.body, symbolize_names: true)

        expect(actual_body).to eq(expected_body)
      end
    end

    context 'with invalid params' do
      let(:invalid_params) do
        {
          user: {
            # Missing required params
          },
          device: {
            # Missing required params
          }
        }
      end

      it 'does not create a new user and device' do
        expect {
          post :create, params: invalid_params
        }.not_to change(User, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end


def expected_response_body(user, device)
  {
    message: 'Success',
    data: {
      user: {
        id: user.id,
        user_type: 'user',
        name: user.name,
        email: user.email,
        status: user.status,
        country_code: user.country_code,
        phone_number: user.phone_number
      },
      device: {
        id: device.id,
        authenticable_type: 'User',
        authenticable_id: user.id,
        fcm_token: device.fcm_token,
        device_type: device.device_type,
        logged_out: device.logged_out,
        locale: 'en',
        created_at: device.created_at.strftime('%Y-%m-%dT%H:%M:%S.%LZ'),
        updated_at: device.updated_at.strftime('%Y-%m-%dT%H:%M:%S.%LZ')
      },
      extra: {
        access_token: user.get_token(device.id)
      }
    }
  }
end
