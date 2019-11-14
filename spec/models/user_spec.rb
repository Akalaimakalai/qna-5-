require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '#is_author?' do
    let(:user) { create(:user) }

    context 'user is the author of the @question' do
      let(:question) { create(:question, user: user) }

      # Я уже вообще не понимаю ничего. Какой вариант лучше?
      it 'returns true' do
        # Этот: 
        expect(user).to be_is_author(question.user_id)
      end
    end

    context 'user is not the author of the @question' do
      let(:question) { create(:question) }

      it 'returns false' do
        # Или вот этот:
        expect(user.is_author?(question.user_id)).to be false
      end
    end
  end
end
