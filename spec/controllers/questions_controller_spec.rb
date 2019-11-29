require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:question2) { create(:question, title: "CheckTitle", body: "CheckBody", user: user) }
  let(:question_with_file) { create(:question, :with_file, user: user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns a new answer to @answer' do
      expect(assigns(:answer)).to be_new_record
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do

    context 'Authenticated user' do
      before { login(user) }
      before { get :new }

      it 'assigns a new Question to @question' do
        expect(assigns(:question)).to be_a_new(Question)
      end

      it 'renders new view' do
        expect(response).to render_template :new
      end
    end

    context 'Unauthenticated user' do
      before { get :new }

      it 'redirects to sing in' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'GET #edit' do

    context 'Authenticated user' do
      before { login(user) }
      before { get :edit, params: { id: question } }

      it 'assigns the requested question to @question' do
        expect(assigns(:question)).to eq question
      end

      it 'renders edit view' do
        expect(response).to render_template :edit
      end
    end

    context 'Unauthenticated user' do
      before { get :edit, params: { id: question } }

      it 'redirects to sing in' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'POST #create' do

    context 'Authenticated user' do
      before { login(user) }

      context 'with valid attributes' do
        before { post :create, params: { question: attributes_for(:question) } }
        it 'saves a new question in the database' do
          expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
        end

        it 'binds question to user' do
          expect(assigns(:question).user).to eq user
        end

        it 'redirects to show view' do
          expect(response).to redirect_to assigns(:question)
        end
      end

      context 'with invalid attributes' do

        it 'does not save the question' do
          expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
        end

        it 're-renders new view' do
          post :create, params: { question: attributes_for(:question, :invalid) }
          expect(response).to render_template :new
        end
      end
    end

    context 'Unauthenticated user' do
      before { post :create, params: { question: attributes_for(:question) } }

      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question) } }.to_not change(Question, :count)
      end

      it 'redirects to sing in' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'PATCH #update' do

    context 'Authenticated user' do

      context 'user is an author' do
        before { login(user) }

        it 'has to prove that user is an author' do
          expect(user).to be_is_author(question)
        end

        context 'with valid attributes' do
          it 'assigns the requested question to @question' do
            patch :update, params: { id: question, question: attributes_for(:question), format: :js }
            expect(assigns(:question)).to eq question
          end

          it 'changes questions attributes' do
            patch :update, params: { id: question, question: { title: 'new title', body: 'new body' }, format: :js }
            question.reload

            expect(question.title).to eq 'new title'
            expect(question.body).to eq 'new body'
          end

          it 'render template update' do
            patch :update, params: { id: question, question: attributes_for(:question), format: :js }
            expect(response).to render_template :update
          end
        end

        context 'with invalid attributes' do
          let(:question) { create(:question, title: "CheckTitle", body: "CheckBody") }
          before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js }

          it 'does not change the question' do
            question2.reload

            expect(question2.title).to eq 'CheckTitle'
            expect(question2.body).to eq 'CheckBody'
          end

          it 'render template update' do
            expect(response).to render_template :update
          end
        end
      end

      context 'user is NOT an author' do
        before do
          login(user2)
          patch :update, params: { id: question2, question: { title: 'new title', body: 'new body' }, format: :js }
        end

        it 'has to prove that user is NOT an author' do
          expect(user2).to_not be_is_author(question)
        end

        it 'does not change the question' do
          question2.reload

          expect(question2.title).to eq 'CheckTitle'
          expect(question2.body).to eq 'CheckBody'
        end

        it 'render template update' do
          expect(response).to render_template :update
        end
      end
    end

    context 'Unauthenticated user' do
      before { patch :update, params: { id: question2, question: attributes_for(:question) }, format: :js }

      it 'does not change the question' do
        question2.reload

        expect(question2.title).to eq 'CheckTitle'
        expect(question2.body).to eq 'CheckBody'
      end

      it 'declares user is unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE #destroy' do

    context 'Authenticated user' do
      context 'user is an author' do
        let!(:question) { create(:question, user: user) }

        before { login(user) }

        it 'has to prove that user is an author' do
          delete :destroy, params: { id: question }
          expect(user).to be_is_author(question)
        end

        it 'deletes the question' do
          expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
        end

        it 'redirects to index' do
          delete :destroy, params: { id: question }
          expect(response).to redirect_to questions_path
        end
      end

      context "user is NOT an author" do
        let!(:question) { create(:question) }

        before do
          login(user2)
          delete :destroy, params: { id: question }
        end

        it 'has to prove that user is NOT an author' do
          expect(user2).to_not be_is_author(question)
        end

        it 'does not delete the question' do
          expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
        end

        it 'redirect to @question' do
          expect(response).to redirect_to question
        end
      end
    end

    context 'Unauthenticated user' do
      before { delete :destroy, params: { id: question } }

      it 'does not delete the question' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end

      it 'redirects to sing in' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'Delete #destroy_file' do
    let(:file_id) { question_with_file.files.first.id }

    context 'Authenticated user' do

      context 'user is an author' do
        before { login(user) }

        it 'has to prove that user is an author' do
          delete :destroy_file, params: { id: question_with_file, file_id: file_id, format: :js }
          expect(user).to be_is_author(question_with_file)
        end

        it "sets file's id to @file_id" do
          delete :destroy_file, params: { id: question_with_file, file_id: file_id, format: :js }
          expect(assigns(:file_id).to_i).to eq file_id
        end

        it 'deletes the file' do
          expect { delete :destroy_file, params: { id: question_with_file, file_id: file_id, format: :js } }.to change(question_with_file.files, :count).by(-1)
        end

        it 'renders destroy_file template' do
          delete :destroy_file, params: { id: question_with_file, file_id: file_id, format: :js }
          expect(response).to render_template :destroy_file
        end
      end

      context "user is NOT an author" do
        before do
          login(user2)
          delete :destroy_file, params: { id: question_with_file, file_id: file_id, format: :js }
        end

        it 'has to prove that user is NOT an author' do
          expect(user2).to_not be_is_author(question_with_file)
        end

        it 'does not delete the file' do
          expect { delete :destroy_file, params: { id: question_with_file, file_id: file_id, format: :js } }.to_not change(question_with_file.files, :count)
        end

        it 'renders destroy_file template' do
          expect(response).to render_template :destroy_file
        end
      end
    end

    context 'Unauthenticated user' do
      it 'does not delete the file' do
        expect { delete :destroy_file, params: { id: question_with_file, file_id: file_id, format: :js } }.to_not change(question_with_file.files, :count)
      end

      it 'declares user is unauthorized' do
        delete :destroy_file, params: { id: question_with_file, file_id: file_id, format: :js }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
