require 'rails_helper'

RSpec.describe EvaluationsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:spot) { create(:spot) }

  describe 'GET #getEvaluationRecord' do
    context 'when the evaluation does not exist' do
      it 'creates a new evaluation and redirects to the evaluate spot path' do
        expect {
          get :getEvaluationRecord, params: { evaluation: { user_id: user.id, spot_id: spot.id, starsAmount: 3 } }
        }.to change(Evaluation, :count).by(1)

        expect(response).to redirect_to(evaluate_spot_path(user_id: user.id, id: spot.id, stars_amount: 0))
      end
    end

    context 'when the evaluation already exists' do
      let!(:evaluation) { create(:evaluation, user: user, spot: spot, starsAmount: 3) }

      it 'redirects to the evaluate spot path with the existing stars amount' do
        get :getEvaluationRecord, params: { evaluation: { user_id: user.id, spot_id: spot.id, starsAmount: 5 } }

        expect(response).to redirect_to(evaluate_spot_path(user_id: user.id, id: spot.id, stars_amount: 0))
      end
    end

    context 'when there is an error saving the evaluation' do
      before do
        allow_any_instance_of(Evaluation).to receive(:save).and_return(false)
      end

      it 'returns an internal server error' do
        get :getEvaluationRecord, params: { evaluation: { user_id: user.id, spot_id: spot.id, starsAmount: 0 } }

        expect(response).to have_http_status(:internal_server_error)
      end
    end
  end
end
