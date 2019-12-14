require 'rails_helper'

RSpec.describe ScoresController, type: :controller do

  let(:user) { create(:user) }
  let!(:score) { create(:score) }

  describe 'PATCH #vote' do
    context 'Authenticated user' do

      before { login(user) }

      context 'with valid vote param' do

        it 'sets correct score to @score' do
          patch :vote, params: { id: score, vote: "vote_for" }, format: :js
          expect(assigns(:score)).to eq score
        end

        context 'vote_for' do
          it 'increases sum value' do
            expect{ patch :vote, params: { id: score, vote: "vote_for" }, format: :js }.to change(score, :sum).by(1)
          end
        end

        context 'vote_against' do
          it 'decreases sum value' do
            expect{ patch :vote, params: { id: score, vote: "vote_against" }, format: :js }.to change(score, :sum).by(-1)
          end
        end

        it 'renders vote template' do
          patch :vote, params: { id: score, vote: "vote_for" }, format: :js
          expect(response).to render_template :vote
        end

      end

      context 'with invalid vote param' do
      end
    end

    context 'Unauthenticated user' do
      it 'redirects to sing in' do
        patch :vote, params: { id: score, vote: "vote_for" }, format: :js
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

end
