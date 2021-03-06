RSpec.shared_examples "votes" do |arg|
  it { should have_many(:votes).dependent(:destroy) }

  let(:user) { create(:user) }
  let!(:resource) { create(arg) }
  let!(:vote) { create(:vote, user: user, votable: resource) }

  describe '#sum_votes' do
    it 'count votes' do
      expect(resource.sum_votes).to eq 1
    end
  end

  describe '#delete_voter(user)' do
    it "deletes user's vote" do
      resource.delete_voter(user)
      expect(resource.votes).to be_empty
    end
  end
end
