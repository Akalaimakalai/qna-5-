require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }
  it { should have_one(:gist).dependent(:destroy) }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  let(:question) { create(:question) }
  let(:correct_link) { create(:link, linkable: question) }

  describe '#validate_url' do
    let(:uncorrect_link) { Link.new(name: "OkName", url: "NotOkUrl", linkable: question) }

    it 'adds error if url is uncorrect' do
      uncorrect_link.valid?
      expect(uncorrect_link.errors.full_messages.first).to eq "Url it's not a url"
    end

    it 'lets create correct url' do
      expect(correct_link).to be_valid
    end
  end

  describe '#set_gist' do

    context 'url is a gist' do
      let(:link_with_gist) { create(:link, :gist, linkable: question) }

      it 'creates gist' do
        expect(link_with_gist.gist).to_not be_nil
      end
    end

    context 'url is not a gist' do

      it 'does not create a gist' do
        expect(correct_link.gist).to be_nil
      end
    end
  end
end
