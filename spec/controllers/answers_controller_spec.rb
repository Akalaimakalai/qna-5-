require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  describe 'POST #create' do

    let(:params) { { question_id: question, answer: attributes_for(:answer).merge({ question_id: question }) } }

    context 'Authenticated user' do

      before { login(user) }

      context 'with valid attributes' do
        it 'saves the answer' do
          expect{ post :create, params: params, format: :js }.to change(Answer, :count).by(1)
        end

        it 'associates with correct question' do
          post :create, params: params, format: :js
          expect(assigns(:answer).question).to eq question
        end

        it 'render template create' do
          post :create, params: params, format: :js
          expect(response).to render_template :create
        end
      end

      context 'with invalid attributes' do
        let(:params) { { question_id: question, answer: attributes_for(:answer, :invalid).merge({ question_id: question }) } }

        it 'does not save the answer' do
          expect{ post :create, params: params, format: :js }.to_not change(Answer, :count)
        end

        it 'render template create' do
          post :create, params: params, format: :js
          expect(response).to render_template :create
        end
      end
    end

    context 'Unauthenticated user' do
      before { post :create, params: params, format: :js }

      it 'does not save the answer' do
        expect{ post :create, params: params, format: :js }.to_not change(Answer, :count)
      end

      it 'declares user is unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET #edit' do

    context 'Authenticated user' do
      before do
        login(user)
        get :edit, params: { id: answer }
      end

      it 'assigns the requested answer to @answer' do
        expect(assigns(:answer)).to eq answer
      end

      it 'renders edit view' do
        expect(response).to render_template :edit
      end
    end

    context 'Unauthenticated user' do
      before { get :edit, params: { id: answer } }

      it 'redirects to sing in' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'GET #show' do

    context 'Authenticated user' do
      before do
        login(user)
        get :show, params: { id: answer }
      end

      it 'assigns the requested answer to @answer' do
        expect(assigns(:answer)).to eq answer
      end

      it 'renders show view' do
        expect(response).to render_template :show
      end
    end

    context 'Unauthenticated user' do
      before { get :show, params: { id: answer } }

      it 'redirects to sing in' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'PATCH #update' do

    context 'Authenticated user' do
      before { login(user) }

      context 'user is an author' do

        it 'has to prove that user is an author' do
          patch :update, params: { id: answer, answer: { body: 'new body' }, format: :js }
          expect(user).to be_is_author(answer)
        end

        context 'with valid attributes' do
          before { patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js }

          it 'updates the @answer' do
            answer.reload
            expect(answer.body).to eq 'new body'
          end

          it 'render template update' do
            expect(response).to render_template :update
          end
        end

        context 'with invalid attributes' do
          before { patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js }

          it 'does not update the answer' do
            answer.reload
            expect(answer.body).to eq "MyAnswerText"
          end

          it 'render template update' do
            expect(response).to render_template :update
          end
        end
      end

      context 'user is NOT an author' do

        before do
          login(user2)
          patch :update, params: { id: answer, answer: { body: 'new body' }, format: :js }
        end

        it 'has to prove that user is NOT an author' do
          expect(user2).to_not be_is_author(answer)
        end

        it 'does not update the answer' do
          answer.reload
          expect(answer.body).to eq "MyAnswerText"
        end

        it 'render template update' do
          expect(response).to render_template :update
        end
      end
    end

    context 'Unauthenticated user' do
      before { patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js }

      it 'does not update the answer' do
        answer.reload
        expect(answer.body).to eq "MyAnswerText"
      end

      it 'declares user is unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE #destroy' do

    let!(:answer) { create(:answer, question: question, user: user) }

    context 'Authenticated user' do

      context 'user is an author' do
        before { login(user) }

        it 'has to prove that user is an author' do
          delete :destroy, params: { id: answer }, format: :js
          expect(user).to be_is_author(answer)
        end

        it 'deletes the answer' do
          expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
        end

        it 'renders destroy template' do
          delete :destroy, params: { id: answer }, format: :js
          expect(response).to render_template :destroy
        end
      end

      context 'user is NOT an author' do
        let!(:answer2) { create(:answer, question: question) }

        before { login(user2) }

        it 'has to prove that user is NOT an author' do
          expect(user2).to_not be_is_author(answer)
        end

        it 'does not delete the answer' do
          expect { delete :destroy, params: { id: answer2 }, format: :js }.to_not change(Answer, :count)
        end

        it 'renders destroy template' do
          delete :destroy, params: { id: answer }, format: :js
          expect(response).to render_template :destroy
        end
      end
    end

    context 'Unauthenticated user' do
      before { delete :destroy, params: { id: answer }, format: :js }

      it 'does not delete the answer' do
        expect { delete :destroy, params: { id: answer } }.to_not change(Answer, :count)
      end

      it 'declares user is unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST #best' do

    context 'Authenticated user' do
      context 'user is an author' do
        before do
          login(user)
          post :best, params: { id: answer }
        end

        it 'has to prove that user is an author' do
          expect(user).to be_is_author(assigns(:question))
        end

        it 'sets answer as correct' do
          expect(assigns(:answer)).to be_correct
        end

        it 'redirect to @question' do
          expect(response).to redirect_to question_path(question)
        end
      end

      context 'user is NOT an author' do

        before do
          login(user2)
          post :best, params: { id: answer }
        end

        it 'has to prove that user is NOT an author' do
          expect(user2).to_not be_is_author(question)
        end

        it 'does not set answer as correct' do
          expect(assigns(:answer)).to_not be_correct
        end

        it 'redirect to @question' do
          expect(response).to redirect_to question_path(question)
        end
      end
    end

    context 'Unauthenticated user' do
      before { post :best, params: { id: answer } }

      it 'does not set answer as correct' do
        expect(answer).to_not be_correct
      end

      it 'redirects to sing in' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
