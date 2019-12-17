require 'rails_helper'

RSpec.describe ScoresController, type: :controller do

  let(:user) { create(:user) }
  let!(:score) { create(:score) }
  let(:user_score) {create(:score, voters: { user.id.to_s => "1" }) }
  let(:author_score) {create(:score, author: user) }

  describe 'PATCH #vote' do
    context 'Authenticated user' do

      before { login(user) }

      context 'with valid vote param' do

        context 'vote_for' do

          it 'increases sum value' do
            patch :vote, params: { id: score, vote: "vote_for" }, format: :json
            score.reload
            expect(score.sum).to eq 1
          end

          it 'correct adds user to voters' do
            patch :vote, params: { id: score, vote: "vote_for" }, format: :json
            score.reload
            expect(score.voters[user.id.to_s]).to eq "1"
          end
        end

        context 'vote_against' do

          it 'decreases sum value' do
            patch :vote, params: { id: score, vote: "vote_against" }, format: :json
            score.reload
            expect(score.sum).to eq -1
          end

          it 'correct adds user to voters' do
            patch :vote, params: { id: score, vote: "vote_against" }, format: :json
            score.reload
            expect(score.voters[user.id.to_s]).to eq "-1"
          end
        end
      end

      context 'with invalid vote param' do
        it 'does not change sum value' do
          patch :vote, params: { id: score, vote: "against_all" }, format: :js
          score.reload
          expect(score.sum).to eq 0
        end

        it 'does not add user to voters' do
          patch :vote, params: { id: score, vote: "against_all" }, format: :js
          score.reload
          expect(score.voters[user.id.to_s]).to be_nil
        end

        it 'gives flash alert' do
          patch :vote, params: { id: score, vote: "against_all" }, format: :js
          expect(response).to render_template :vote
          expect(flash[:alert]).to eq "Wrong value of vote param"
        end
      end

      context 'has already voted' do
        it 'does not change sum value' do
          patch :vote, params: { id: score, vote: "against_all" }, format: :js
          score.reload
          expect(score.sum).to eq 0
        end

        it 'gives flash alert' do
          patch :vote, params: { id: user_score, vote: "vote_for" }, format: :js
          expect(response).to render_template :vote
          expect(flash[:alert]).to eq "You have already voted"
        end
      end

      context 'user is author' do
        it 'does not change sum value' do
          patch :vote, params: { id: author_score, vote: "vote_for" }, format: :js
          score.reload
          expect(score.sum).to eq 0
        end

        it 'does not add user to voters' do
          patch :vote, params: { id: score, vote: "against_all" }, format: :js
          score.reload
          expect(score.voters[user.id.to_s]).to be_nil
        end

        it 'gives flash alert' do
          patch :vote, params: { id: author_score, vote: "vote_for" }, format: :js
          expect(response).to render_template :vote
          expect(flash[:alert]).to eq "You can't vote for yourself"
        end
      end
    end

    context 'Unauthenticated user' do

      it 'does not change sum value' do
        patch :vote, params: { id: score, vote: "against_all" }, format: :js
        score.reload
        expect(score.sum).to eq 0
      end

      it 'does not add user to voters' do
        patch :vote, params: { id: score, vote: "against_all" }, format: :js
        score.reload
        expect(score.voters[user.id.to_s]).to be_nil
      end

      it 'declares user is unauthorized' do
        patch :vote, params: { id: score, vote: "vote_for" }, format: :js
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PATCH #revote' do
    context 'Authenticated user' do

      before { login(user) }

      context 'has alresdy voted' do

        it 'deletes user from voters' do
          patch :revote, params: { id: user_score }, format: :json
          score.reload
          expect(score.voters[user.id.to_s]).to be_nil
        end

        it 'changes sum value' do
          patch :revote, params: { id: user_score }, format: :json
          score.reload
          expect(score.sum).to eq 0
        end
      end

      context 'did not vote yet' do
        it 'does not change sum value' do
          patch :revote, params: { id: score }, format: :js
          score.reload
          expect(score.sum).to eq 0
        end

        it 'does not add user to voters' do
          patch :revote, params: { id: score }, format: :js
          score.reload
          expect(score.voters[user.id.to_s]).to be_nil
        end

        it 'gives flash alert' do
          patch :revote, params: { id: score }, format: :js
          expect(response).to render_template :revote
          expect(flash[:alert]).to eq "You didn't vote yet"
        end
      end
    end

    context 'Unauthenticated user' do

      it 'does not change sum value' do
        patch :revote, params: { id: user_score }, format: :js
        user_score.reload
        expect(user_score.sum).to eq 0
      end

      it 'does not delete user from voters' do
        patch :revote, params: { id: user_score }, format: :js
        user_score.reload
        expect(user_score.voters[user.id.to_s]).to eq "1"
      end

      it 'declares user is unauthorized' do
        patch :revote, params: { id: user_score }, format: :js
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
