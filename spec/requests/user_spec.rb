require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user) }
  let(:auth_info) { create(:auth_info, user: user) }

  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #getCurrentUser' do
    context 'when authInfo exists' do
      it 'returns the user associated with the given uid' do
        get :getCurrentUser, params: { uid: auth_info.id }
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)["id"]).to eq(user.id)
      end
    end

    context 'when authInfo does not exist' do
      it 'returns an error if the authInfo is not found' do
        get :getCurrentUser, params: { uid: '0000000' }
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)['error']).to eq('認証情報が見つかりませんでした')
      end
    end

    context 'when user does not exist' do
      it 'returns an error if the user is not found' do
        allow(AuthInfo).to receive(:find_by).and_return(auth_info)
        allow(User).to receive(:find_by).and_return(nil)

        get :getCurrentUser, params: { uid: auth_info.id }
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)['error']).to eq('ユーザーが見つかりませんでした')
      end
    end
  end

  describe 'POST #create' do
    context 'when authInfo exists' do
      it 'does not create a new user, returns success' do
        post :create, params: { uid: auth_info.id }
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when authInfo does not exist' do
      it 'creates a new user and authInfo' do
        expect {
          post :create, params: { uid: '001', name: 'New User', email: 'new@example.com', provider: 'google' }
        }.to change(User, :count).by(1).and change(AuthInfo, :count).by(1)

        expect(response).to have_http_status(:ok)
      end
    end

    context 'when user or authInfo creation fails' do
      it 'returns internal server error' do
        allow(User).to receive(:create).and_raise(StandardError.new('something went wrong'))
        post :create, params: { uid: '001', name: 'New User', email: 'new@example.com', provider: 'google' }

        expect(response).to have_http_status(:internal_server_error)
        expect(JSON.parse(response.body)['error']).to eq('something went wrong')
      end
    end
  end
end
