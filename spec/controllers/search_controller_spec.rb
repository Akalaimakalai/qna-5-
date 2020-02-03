require 'sphinx_helper'

RSpec.describe SearchController, type: :controller do

  describe 'GET #index'do
    let!(:question) { create(:question, title: 'test title') }

    before do
      expect(ThinkingSphinx).to receive(:search).with('test', classes: [nil]).and_return([question])
      get :index, params: { search: 'test', classes: 'Везде' }
    end

    it 'collects all into @results' do
      expect(assigns(:results)).to be_include(question)
    end

    it 'renders template index' do
      expect(response).to render_template(:index)
    end
  end
end
