require 'rails_helper'

RSpec.describe SearchController, type: :controller do

  describe 'GET #index'do
    let!(:question) { create(:question, title: 'test question') }
    let!(:answer) { create(:answer, body: 'test answer') }
    let!(:comment) { create(:comment, body: 'test comment', commentable: question) }
    let!(:user) { create(:user, email: 'test@mail.com') }

    it 'collects all into @results when we search everywhere' do
      expect(SearchService).to receive(:do_search).with('test', 'Везде').and_return([question, answer, comment, user])
      get :index, params: { search: 'test', classes: 'Везде' }
      expect(assigns(:results)).to eq [question, answer, comment, user]
    end

    it 'collects question into @results when we search in Question' do
      expect(SearchService).to receive(:do_search).with('test', 'Вопросы').and_return([question])
      get :index, params: { search: 'test', classes: 'Вопросы' }
      expect(assigns(:results)).to eq [question]
    end

    it 'collects answer into @results when we search in Answer' do
      expect(SearchService).to receive(:do_search).with('test', 'Ответы').and_return([answer])
      get :index, params: { search: 'test', classes: 'Ответы' }
      expect(assigns(:results)).to eq [answer]
    end

    it 'collects comment into @results when we search in Comment' do
      expect(SearchService).to receive(:do_search).with('test', 'Комментарии').and_return([comment])
      get :index, params: { search: 'test', classes: 'Комментарии' }
      expect(assigns(:results)).to eq [comment]
    end

    it 'collects user into @results when we search in User' do
      expect(SearchService).to receive(:do_search).with('test', 'Пользователи').and_return([user])
      get :index, params: { search: 'test', classes: 'Пользователи' }
      expect(assigns(:results)).to eq [user]
    end

    it 'sets empty array to @results when we search in UnknownKlass' do
      expect(SearchService).to receive(:do_search).with('test', 'UnknownKlass').and_return([])
      get :index, params: { search: 'test', classes: 'UnknownKlass' }
      expect(assigns(:results)).to eq []
    end

    it 'renders template index' do
      expect(SearchService).to receive(:do_search).with('test', 'Везде')
      get :index, params: { search: 'test', classes: 'Везде' }
      expect(response).to render_template(:index)
    end
  end
end
