require 'rails_helper'

RSpec.describe ScoresController, type: :controller do

  let(:user) { create(:user) }
  let!(:score) { create(:score) }
  let(:user_score) {create(:score, voters: { user.id.to_s => "1" }) }

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
            patch :vote, params: { id: score, vote: "vote_for" }, format: :js
            score.reload
            expect(score.sum).to eq 1
          end

          it 'correct adds user to voters' do
            patch :vote, params: { id: score, vote: "vote_for" }, format: :js
            score.reload
            expect(score.voters[user.id.to_s]).to eq "1"
          end
        end

        context 'vote_against' do

          it 'decreases sum value' do
            patch :vote, params: { id: score, vote: "vote_against" }, format: :js
            score.reload
            expect(score.sum).to eq -1
          end

          it 'correct adds user to voters' do
            patch :vote, params: { id: score, vote: "vote_against" }, format: :js
            score.reload
            expect(score.voters[user.id.to_s]).to eq "-1"
          end
        end

        it 'renders vote template' do
          patch :vote, params: { id: score, vote: "vote_for" }, format: :js
          expect(response).to render_template :vote
        end
      end

      context 'with invalid vote param' do
        it 'does not change sum value' do
          patch :vote, params: { id: score, vote: "against_all" }, format: :js
          score.reload
          expect(score.sum).to eq 0
        end

        it 'gives flash alert' do
          patch :vote, params: { id: score, vote: "against_all" }, format: :js
          expect(response).to render_template :vote
          expect(flash[:alert]).to eq "Wrong value of vote param"
        end
      end

      context 'has already voted' do
        it 'gives flash alert' do
          patch :vote, params: { id: user_score, vote: "vote_for" }, format: :js
          expect(response).to render_template :vote
          expect(flash[:alert]).to eq "You have already voted"
        end
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
