require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers) }
  it { should have_many(:medals) }
  it { should have_many(:votes) }
  it { should have_many(:comments) }
  it { should have_many(:authorizations).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }
  it { should have_many(:subs).through(:subscriptions).source(:question) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

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
  end

  describe '#find_sub(question)' do
    let(:subscription) { user.subscriptions.first }

    it 'finds subscription' do
      expect(user.find_sub(question)).to eq subscription
    end
  end
end
