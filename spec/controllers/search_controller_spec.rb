require 'rails_helper'

RSpec.describe SearchController, type: :controller do

  describe 'GET #index'do
    let(:service) { double('SearchService') }

    before { allow(SearchService).to receive(:new).and_return(service) }

    context "all categories" do
      it_behaves_like 'searchable' do
        let(:klass){ 'Везде' }
      end
    end

    context "Question" do
      it_behaves_like 'searchable' do
        let(:klass){ 'Вопросы' }
      end
    end

    context "Answer" do
      it_behaves_like 'searchable' do
        let(:klass){ 'Ответы' }
      end
    end

    context "Comment" do
      it_behaves_like 'searchable' do
        let(:klass){ 'Комментарии' }
      end
    end

    context "User" do
      it_behaves_like 'searchable' do
        let(:klass){ 'Пользователи' }
      end
    end

    context "Unknown category" do
      it_behaves_like 'searchable' do
        let(:klass){ 'UnknownKlass' }
      end
    end
  end
end
