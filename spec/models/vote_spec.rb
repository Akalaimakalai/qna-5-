require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to :votable }
  it { should belong_to :user }
  it { should validate_presence_of :value }
  it { should validate_inclusion_of(:value).in_array([ 1, -1 ]) }

  describe 'before_create' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let!(:vote) { create(:vote, user: user, votable: question) }

    it 'deletes previous votes of user' do
      new_vote = create(:vote, user: user, votable: question)

      expect(user.votes).to_not include(vote)
      expect(user.votes).to include(new_vote)
    end
  end
end
