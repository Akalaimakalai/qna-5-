require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { create(:user) }

  describe 'POST #create' do
    let!(:question) { create(:question) }

    context 'Authenticated user' do

      before { login(user) }

      context 'is not following question yet' do

        it 'creates subscription' do
          expect{ post :create, params: { question_id: question }, format: :js }.to change(Subscription, :count).by(1)
        end

        it 'creates subscription with correct attr' do
          post :create, params: { question_id: question }, format: :js
          expect(Subscription.order(created_at: :asc).last.question).to eq question
          expect(Subscription.order(created_at: :asc).last.user).to eq user
        end

        it 'renders template :create' do
          post :create, params: { question_id: question }, format: :js
          expect(response).to render_template(:create)
        end
      end

      context 'is following question' do
        let!(:question) { create(:question, user: user) }

        it 'does not save the subscription' do
          expect{ post :create, params: { question_id: question }, format: :js }.to_not change(Subscription, :count)
        end

        it 'renders template :create' do
          post :create, params: { question_id: question }, format: :js
          expect(response).to render_template(:create)
        end
      end
    end

    context 'Unauthenticated user' do

      it 'does not save the subscription' do
        expect{ post :create, params: { question_id: question }, format: :js }.to_not change(Subscription, :count)
      end

      it 'redirects to root' do
        post :create, params: { question_id: question }, format: :js
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question, user: user) }
    let(:subscription) { user.find_sub(question) }

    context 'Authenticated user' do

      before { login(user) }

      it 'deletes subscrption' do
        expect{ delete :destroy, params: { id: subscription }, format: :js }.to change(Subscription, :count).by(-1)
      end

      it 'renders template :destroy' do
        delete :destroy, params: { id: subscription }, format: :js
        expect(response).to render_template(:destroy)
      end
    end

    context 'Unauthenticated user' do

      it 'does not save the subscription' do
        expect{ delete :destroy, params: { id: subscription }, format: :js }.to_not change(Subscription, :count)
      end

      it 'redirects to root' do
        delete :destroy, params: { id: subscription }, format: :js
        expect(response).to redirect_to root_path
      end
    end
  end
end
