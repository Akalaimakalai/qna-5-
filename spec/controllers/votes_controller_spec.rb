require 'rails_helper'

RSpec.describe VotesController, type: :controller do

  describe 'POST #create' do

    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let(:user_question) { create(:question, user: user) }
    let(:params) { { vote: { votable_type: question.class.name, votable_id: question.id, value: 1 } } }

    context 'Authenticated user' do
      before { login(user) }

      context 'is author of the record' do
        let(:params) { { vote: { votable_type: user_question.class.name, votable_id: user_question.id, value: 1 } } }

        it 'does not create vote' do
          expect { post :create, params: params, format: :json }.to_not change(Vote, :count)
        end
      end

      context 'is NOT author of the record' do

        it 'create new vote' do
          expect { post :create, params: params, format: :json }.to change(Vote, :count).by(1)
        end

        it 'returns correct json' do
          post :create, params: params, format: :json
          expect(JSON.parse(response.body)).to eq({ 'id' => question.id,
                                                    'klass' => question.class.name.underscore,
                                                    'sum' => 1 })
        end
      end
    end

    context 'Unauthenticated user' do
      before { post :create, params: params, format: :js }

      it 'does not save the vote' do
        expect{ post :create, params: params, format: :js }.to_not change(Vote, :count)
      end

      it 'declares user is unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
