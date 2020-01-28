require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do

  describe 'POST #create' do
    let!(:question) { create(:question) }

    context 'Authenticated user' do
      let(:user) { create(:user) }

      before { login(user) }

      context 'is not following question yet' do
        let(:params) { { resource: { id: question } } }

        it 'creates subscription' do
          expect{ post :create, params: params, format: :js }.to change(Subscription, :count).by(1)
        end

        it 'rensers template :create' do
          post :create, params: params, format: :js
          expect(response).to render_template(:create)
        end
      end

      context 'is following question' do
        let!(:question) { create(:question, user: user) }
        let(:params) { { resource: { id: question } } }

        it 'does not save the subscription' do
          expect{ post :create, params: params, format: :js }.to_not change(Subscription, :count)
        end

        it 'rensers template :create' do
          post :create, params: params, format: :js
          expect(response).to render_template(:create)
        end

        it 'shows alert' do
          post :create, params: params, format: :js
          expect(flash[:alert]).to eq "You are already following question"
        end
      end
    end

    context 'Unauthenticated user' do
      let(:params) { { resource: { id: question } } }

      before { post :create, params: params, format: :js }

      it 'does not save the subscription' do
        expect{ post :create, params: params, format: :js }.to_not change(Subscription, :count)
      end

      it 'redirects to root' do
        expect(response).to redirect_to root_path
      end
    end
  end
end
