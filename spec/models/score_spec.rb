require 'rails_helper'

RSpec.describe Score, type: :model do
  it { should belong_to(:scorable) }
  it { should belong_to(:author) }

  it { should validate_presence_of(:sum) }

  let(:user) { create(:user) }
  let(:score) { create(:score) }
  let(:user_score) {create(:score, voters: { user.id.to_s => "1" }) }

  describe '#already_voted?' do
    context 'user did not vote yet' do
      it 'returns false' do
        expect(score).to_not be_already_voted(user.id)
      end
    end

    context 'user has already voted' do
      it 'returns true' do
        expect(user_score).to be_already_voted(user.id)
      end
    end
  end

  describe '#revote' do
    it 'correct changes sum' do
      expect { user_score.revote(user.id) }.to change(user_score, :sum).by(-1)
    end

    it 'deletes user_id from voters' do
      user_score.revote(user.id)
      expect(user_score.voters[user.id.to_s]).to be_nil
    end
  end
end
