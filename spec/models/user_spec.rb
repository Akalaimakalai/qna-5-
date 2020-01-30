require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers) }
  it { should have_many(:medals) }
  it { should have_many(:votes) }
  it { should have_many(:comments) }
  it { should have_many(:authorizations).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }
  it { should have_many(:subscribed_to_questions).through(:subscriptions).source(:question) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:another_question) { create(:question) }

  describe '.find_for_oauth(auth)' do
    let(:auth) { "I am auth" }

    it 'calls FindForOauthService' do
      expect(FindForOauthService).to receive(:call).with(auth)
      User.find_for_oauth(auth)
    end
  end

  describe '#follower?(question)' do

    it 'proofs that user is following question' do
      expect(user).to be_follower(question)
    end

    it 'proofs that user is not following another question' do
      expect(user).to_not be_follower(another_question)
    end
  end

  describe '#find_sub(question)' do
    let(:subscription) { user.subscriptions.first }

    it 'finds subscription if it is' do
      expect(user.find_sub(question)).to eq subscription
    end

    it 'does not find subscription if it is not' do
      expect(user.find_sub(another_question)).to be_nil
    end
  end
end
