require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question, user: user) }

  describe 'POST #create' do

    let(:params) { { question_id: question, answer: attributes_for(:answer).merge({ question_id: question }) } }

    context 'Authenticated user' do

      before { login(user) }

      context 'with valid attributes' do
        it 'saves the answer' do
          expect{ post :create, params: params }.to change(Answer, :count).by(1)
        end

        it 'associates with correct question' do
          post :create, params: params
          expect(assigns(:answer).question).to eq question
        end

        it 'redirects to question show view' do
          post :create, params: params
          expect(response).to redirect_to assigns(:answer).question
        end
      end

      context 'with invalid attributes' do
        let(:params) { { question_id: question, answer: attributes_for(:answer, :invalid).merge({ question_id: question }) } }

        include_context 'does not save the answer'

        it 'render question show view' do
          post :create, params: params
          expect(response).to render_template 'questions/show'
        end
      end
    end

    context 'Unauthenticated user' do
      before { post :create, params: params }

      include_context 'does not save the answer'

      include_context 'Redirects to sing in'
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
      include_context 'Redirects to sing in'
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
      include_context 'Redirects to sing in'
    end
  end

  describe 'PATCH #update' do

    context 'Authenticated user' do
      before { login(user) }

      context 'user is an author' do

        it 'has to prove that user is an author' do
          patch :update, params: { id: answer, answer: { body: 'new body', correct: true } }
          expect(user).to be_is_author(answer)
        end

        context 'with valid attributes' do
          before { patch :update, params: { id: answer, answer: { body: 'new body', correct: true } } }

          it 'updates the @answer' do
            answer.reload
            expect(answer.body).to eq 'new body'
          end

          it 'redirects to updates answer' do
            expect(response).to redirect_to answer
          end
        end

        context 'with invalid attributes' do
          before { patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) } }

          include_context 'does not update the answer'

          it 're-render edit view' do
            expect(response).to render_template :edit
          end
        end
      end

      context 'user is NOT an author' do
        let(:user2) { create(:user) }
        before do
          login(user2)
          patch :update, params: { id: answer, answer: { body: 'new body', correct: true } }
        end

        it 'has to prove that user is NOT an author' do
          expect(user2).to_not be_is_author(answer)
        end

        include_context 'does not update the answer'

        it 're-render edit view' do
          expect(response).to render_template :edit
        end
      end
    end

    context 'Unauthenticated user' do
      before { patch :update, params: { id: answer, answer: { body: 'new body', correct: true } } }

      include_context 'does not update the answer'

      include_context 'Redirects to sing in'
    end
  end

  describe 'DELETE #destroy' do

    let!(:answer) { create(:answer, question: question, user: user) }

    context 'Authenticated user' do

      context 'user is an author' do
        before { login(user) }

        it 'has to prove that user is an author' do
          delete :destroy, params: { id: answer }
          expect(user).to be_is_author(answer)
        end

        it 'deletes the answer' do
          expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
        end

        it 'redirects to index' do
          delete :destroy, params: { id: answer }
          expect(response).to redirect_to question_answers_path(question)
        end
      end

      context 'user is NOT an author' do
        let!(:answer2) { create(:answer) }
        let(:user2) { create(:user) }

        before { login(user2) }

        it 'has to prove that user is NOT an author' do
          expect(user2).to_not be_is_author(answer)
        end

        it 'does not delete the answer' do
          expect { delete :destroy, params: { id: answer2 } }.to_not change(Answer, :count)
        end

        it 'redirect to @question' do
          delete :destroy, params: { id: answer2 }
          expect(response).to redirect_to answer2.question
        end
      end
    end

    context 'Unauthenticated user' do
      before { delete :destroy, params: { id: answer } }

      it 'does not delete the answer' do
        expect { delete :destroy, params: { id: answer } }.to_not change(Answer, :count)
      end

      include_context 'Redirects to sing in'
    end
  end
end
