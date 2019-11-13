require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to :user }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  describe 'model methods tests' do
    describe '#is_author?' do
      let(:user) { create(:user) }
      context 'user is the author of the @question' do
        it 'returns true' do
          question = create(:question, user: user)
          expect(question.is_author?(user)).to be_truthy
        end
      end

      context 'user is not the author of the @question' do
        it 'returns false' do
          question = create(:question)
          expect(question.is_author?(user)).to be_falsey
        end
      end
    end
  end
end
