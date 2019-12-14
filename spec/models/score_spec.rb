require 'rails_helper'

RSpec.describe Score, type: :model do
  it { should belong_to(:scorable) }
  it { should belong_to(:author) }

  it { should validate_presence_of(:sum) }

  let(:score) { create(:score) }

  describe '#vote_for' do
    it 'increases sum value' do
      expect { score.vote_for }.to change(score, :sum).by(1)
    end
  end

  describe '#vote_against' do
    it 'decreases sum value' do
      expect { score.vote_against }.to change(score, :sum).by(-1)
    end
  end
end
