require 'sphinx_helper'

RSpec.describe SearchService do

  describe 'self.do_search(user_string, search_klass)' do

    context 'user searches empty string' do
      it 'does not initiate search' do
        expect(ThinkingSphinx).to_not receive(:search)
        SearchService.do_search("    ", "Везде")
      end

      it 'returns empty array' do
        expect(SearchService.do_search("    ", "Везде")).to eq []
      end
    end

    context 'user searches in incorrect category' do
      it 'does not initiate search' do
        expect(ThinkingSphinx).to_not receive(:search)
        SearchService.do_search("test", "Imagination")
      end

      it 'returns empty array' do
        expect(SearchService.do_search("test", "Imagination")).to eq []
      end
    end

    context 'user searches what we have' do
      let!(:question) { create(:question, title: 'test question') }

      it 'initiates search' do
        expect(ThinkingSphinx).to receive(:search).with("test", classes: [nil])
        SearchService.do_search("test", "Везде")
      end
    end

    context 'user searches what we do not have' do
      let!(:question) { create(:question, title: 'test question') }

      it 'initiates search' do
        expect(ThinkingSphinx).to receive(:search).with("Happy", classes: [nil])
        SearchService.do_search("Happy", "Везде")
      end
    end
  end
end
