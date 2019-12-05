require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }
  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  describe '#gist?' do
    let(:question) { create(:question) }

    context 'link to gist' do
      let(:link) { create(:link, :gist, linkable: question) }

      it 'returns true' do
        expect(link).to be_gist
      end
    end

    context 'link to not gist' do
      let(:link) { create(:link, linkable: question) }

      it 'returns false' do
        expect(link).to_not be_gist
      end
    end
  end
end
