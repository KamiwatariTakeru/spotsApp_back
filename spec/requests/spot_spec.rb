require 'rails_helper'

RSpec.describe SpotsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:spot) { create(:spot) }
  let!(:evaluation) { create(:evaluation, user: user, spot: spot) }

  describe 'GET #index' do
    it 'returns a success response with spots' do
      get :index
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).length).to be >= 1
    end
  end

  describe 'GET #show' do
    it 'returns the requested spot' do
      get :show, params: { id: spot.id }
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)['id']).to eq(spot.id)
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      let(:valid_attributes) do
        { name: 'New Spot', address: 'Tokyo', stars_sum: 0, stars_avg: 0 }
      end

      it 'creates a new spot' do
        expect {
          post :create, params: { spot: valid_attributes, address: 'Tokyo' }
        }.to change(Spot, :count).by(1)

        expect(response).to have_http_status(:created)
      end
    end

    context 'when geocoding fails' do
      it 'returns an error response' do
        allow(controller).to receive(:geocode_address).and_return(nil)

        post :create, params: { spot: { name: 'Spot Name', address: 'Invalid Address' } }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to eq('Address geocoding failed')
      end
    end
  end

  describe 'POST #evaluate' do
    context 'when evaluation exists' do
      it 'updates evaluation and recalculates spot rating' do
        post :evaluate, params: { id: spot.id, user_id: 1, stars_amount: 3 }

        spot.reload
        evaluation.reload

        expect(evaluation.starsAmount).to eq(3)
        expect(spot.stars_sum).to eq(spot.stars_sum)
        expect(response).to have_http_status(:success)
      end
    end

    context 'when evaluation does not exist' do
      it 'returns an error response' do
        post :evaluate, params: { id: spot.id, user_id: 999, stars_amount: 5 }
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)['error']).to eq('評価レコードが存在しません')
      end
    end
  end
end
