require 'rails_helper'

RSpec.describe Score, type: :model do
  it { should belong_to(:scorable) }
  it { should belong_to(:author) }
  it { should have_many(:votes) }

  it { should validate_presence_of(:sum) }

  let(:score) { create(:score) }
  let(:score_with_vote) { create(:score) }
  let!(:vote) { create(:vote, score: score_with_vote) }

  describe "#delete_voter" do
    it 'deletes the user and his vote from score' do
      score_with_vote.delete_voter(vote.user)
      score_with_vote.reload
      expect(score_with_vote.votes).to be_empty
    end
  end

  describe '#count_sum' do
    it 'counts sum of votes' do
      score_with_vote.count_sum
      expect(score_with_vote.sum).to eq 1
    end
  end
end
