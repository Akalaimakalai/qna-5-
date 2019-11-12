require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }

  describe 'GET #index' do
    let(:answers) { create_list(:answer, 3, question: question) }

    before { get :index, params: { question_id: question } }

    it 'populates an array of all answers' do
      expect(assigns(:answers)).to match_array(answers)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      let(:attrs) { attributes_for(:answer).merge({ question_id: question }) }

      it 'saves the answer' do
        expect{ post :create, params: { question_id: question, answer: attrs } }.to change(Answer, :count).by(1)
      end

      it 'associates with correct question' do
        post :create, params: { question_id: question, answer: attrs }
        expect(assigns(:answer).question).to eq question
      end

      it 'redirects to created answer (show view)'do
        post :create, params: { question_id: question, answer: attrs }
        expect(response).to redirect_to assigns(:answer)
      end
    end

    context 'with invalid attributes' do
      let(:attrs) { attributes_for(:answer, :invalid).merge({ question_id: question }) }

      it 'does not save the answer' do
        expect{ post :create, params: { question_id: question, answer: attrs } }.to_not change(Answer, :count)
      end

      it 're-renders new view' do
        post :create, params: { question_id: question, answer: attrs }
        expect(response).to render_template :new
      end
    end
  end

  describe 'GET #new' do
    before { get :new, params: { question_id: question } }

    it 'assigns a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { get :edit, params: { id: answer } }

    it 'assigns the requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: answer } }

    it 'assigns the requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      before { patch :update, params: { id: answer, answer: { body: 'new body', correct: true } } }

      it 'updates the @answer' do
        answer.reload
        expect(answer.body).to eq 'new body'
        expect(answer.correct).to be_truthy
      end

      it 'redirects to updates answer' do
        expect(response).to redirect_to answer
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) } }

      it 'does not update' do
        answer.reload
        expect(answer.body).to eq 'MyText'
        expect(answer.correct).to be_falsey
      end

      it 're-render edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, question: question) }

    it 'deletes the answer' do
      expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
    end

    it 'redirects to index' do
      delete :destroy, params: { id: answer }
      expect(response).to redirect_to question_answers_path(question)
    end
  end

end
