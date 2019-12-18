require 'rails_helper'

RSpec.describe ScoresController, type: :controller do

  let(:user) { create(:user) }
  let(:score) { create(:score) }
  let(:user_score) { create(:score, author: user) }

  describe 'PATCH #update' do

    context 'Authenticated user' do
      before { login(user) }

      it 'sets correct score to @score' do
        patch :update, params: { id: score, vote: { value: 1 } }, format: :js
        expect(assigns(:score)).to eq score
      end

      context 'user is author' do
        it 'shows flash alert' do
          patch :update, params: { id: user_score, vote: { value: 1 } }, format: :js
          expect(flash[:alert]).to eq "You can't vote for yourself"
        end
      end

      context 'user is NOT author' do
        it 'increases sum correctly' do
          patch :update, params: { id: score, vote: { value: 1 } }, format: :js
          score.reload
          expect(score.sum).to eq 1
        end

        it 'decreases sum correctly' do
          patch :update, params: { id: score, vote: { value: -1 } }, format: :js
          score.reload
          expect(score.sum).to eq -1
        end
      end

      it 'renders update view' do
        patch :update, params: { id: score, vote: { value: 1 } }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'Unauthenticated user' do

      before { patch :update, params: { id: score, vote: { value: 1 } }, format: :js }

      it 'does not change score' do
      end

      it 'declares user is unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
