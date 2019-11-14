require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe 'model methods tests' do
    describe '#is_author?' do
      let(:user) { create(:user) }
      context 'user is the author of the @question' do
        it 'returns true' do
          question = create(:question, user: user)
          expect(user.is_author?(question)).to be_truthy
        end
      end

      context 'user is not the author of the @question' do
        it 'returns false' do
          question = create(:question)
          expect(user.is_author?(question)).to be_falsey
        end
      end
    end
  end
end
