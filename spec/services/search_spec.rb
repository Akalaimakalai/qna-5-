require 'sphinx_helper'

RSpec.describe SearchService do

  describe '#call(query, scope: nil)' do

    context 'user searches empty string' do
      let(:service) { SearchService.new("    ") }

      it 'does not initiate search' do
        expect(ThinkingSphinx).to_not receive(:search)
        service.call
      end

      it 'returns empty array' do
        expect(service.call).to eq []
      end
    end

    context 'user searches in incorrect category' do
      let(:service) { SearchService.new("test", scope: "Imagination") }

      it 'initiates search in all categories' do
        expect(ThinkingSphinx).to receive(:search).with('test', classes: [nil])
        service.call
      end
    end

    context 'user searches what we have' do
      let(:service) { SearchService.new("test", scope: "Везде") }
      let!(:question) { create(:question, title: 'test question') }

      it 'initiates search' do
        expect(ThinkingSphinx).to receive(:search).with("test", classes: [nil])
        service.call
      end
    end

    context 'user searches what we do not have' do
      let(:service) { SearchService.new("Happy", scope: "Везде") }
      let!(:question) { create(:question, title: 'test question') }

      it 'initiates search' do
        expect(ThinkingSphinx).to receive(:search).with("Happy", classes: [nil])
        service.call
      end
    end
  end
end
