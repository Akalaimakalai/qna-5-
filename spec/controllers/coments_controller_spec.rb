require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:question) { create(:question) }

  describe 'POST #create' do
    let(:params) { { question_id: question, comment: { body: "BodyThatCame" } } }

    context 'Authenticated user' do

      before { login(user) }

      it 'sets correct resource to @resource' do
        post :create, params: params, format: :js
        expect(assigns(:resource)).to eq question
      end

      context 'with valid params' do

        it 'saves the comment' do
          expect{ post :create, params: params, format: :js }.to change(Comment, :count).by(1)
        end
      end

      context 'with invalid params' do
        let(:params) { { question_id: question, comment: { body: "" } } }

        it 'does not save the comment' do
          expect{ post :create, params: params, format: :js }.to_not change(Comment, :count)
        end
      end

      it 'render template create' do
        post :create, params: params, format: :js
        expect(response).to render_template :create
      end
    end

    context 'Unauthenticated user' do
      before { post :create, params: params, format: :js }

      it 'does not save comment' do
        expect{ post :create, params: params, format: :js }.to_not change(Comment, :count)
      end

      it 'declares user is unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:comment) { create(:comment, user: user, commentable: question) }

    context 'Authenticated user' do

      context 'user is an author' do
        before { login(user) }

        it 'sets correct comment to @comment' do
          delete :destroy, params: { id: comment }, format: :js
          expect(assigns(:comment)).to eq comment
        end

        it 'deletes comment' do
          expect{ delete :destroy, params: { id: comment }, format: :js }.to change(Comment, :count).by(-1)
        end

        it 'renders template destroy' do
          delete :destroy, params: { id: comment }, format: :js
          expect(response).to render_template :destroy
        end
      end

      context 'user is NOT an author' do
        before { login(user2) }

        it 'sets correct comment to @comment' do
          delete :destroy, params: { id: comment }, format: :js
          expect(assigns(:comment)).to eq comment
        end

        it 'does not delete comment' do
          expect{ delete :destroy, params: { id: comment }, format: :js }.to_not change(Comment, :count)
        end

        it 'resirects to root' do
          delete :destroy, params: { id: comment }, format: :js
          expect(response).to redirect_to root_path
        end
      end
    end

    context 'Unauthenticated user' do
      before { delete :destroy, params: { id: comment }, format: :js }

      it 'does not delete comment' do
        expect{ delete :destroy, params: { id: comment }, format: :js }.to_not change(Comment, :count)
      end

      it 'declares user is unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
