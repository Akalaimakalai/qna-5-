require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers) }
  it { should have_many(:medals).optional }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '#is_author?' do
    let(:user) { create(:user) }

    context 'user is the author of the @question' do
      let(:question) { create(:question, user: user) }

      it 'returns true' do
        expect(user).to be_is_author(question)
      end
    end

    context 'user is not the author of the @question' do
      let(:question) { create(:question) }

      it 'returns false' do
        expect(user).to_not be_is_author(question)
      end
    end
  end
end
