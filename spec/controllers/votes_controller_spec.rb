require 'rails_helper'

RSpec.describe VotesController, type: :controller do

  describe 'POST #create' do

    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let(:user_question) { create(:question, user: user) }
    let(:params) { { vote: { votable_type: question.class.name, votable_id: question.id, value: 1 } } }

    context 'Authenticated user' do
      before { login(user) }

      it 'sets correct object to @record' do
        post :create, params: params , format: :js
        expect(assigns(:record)).to eq question
      end

      context 'is author of the @record' do
        let(:params) { { vote: { votable_type: user_question.class.name, votable_id: user_question.id, value: 1 } } }

        it 'does not create vote' do
          expect { post :create, params: params, format: :js }.to_not change(Vote, :count)
        end

        it 'shows flash alert' do
          post :create, params: params, format: :js
          expect(response).to render_template(:create)
          expect(flash[:alert]).to eq "You can't vote for youself"
        end
      end

      context 'is NOT author of the @record' do

        it 'create new vote' do
          expect { post :create, params: params, format: :js }.to change(Vote, :count).by(1)
        end
      end

      it 'renders template create' do
        post :create, params: params, format: :js
        expect(response).to render_template :create
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
