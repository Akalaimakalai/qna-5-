require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_one(:best_answer) }
  it { should belong_to :user }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  describe '#best?' do
    let(:question) { create(:question) }

    context 'answer is the best' do
      let(:answer) { create(:answer, question: question, best_for: question) }

      it 'returns true' do
        expect(question).to be_best(answer)
      end
    end

    context 'answer is NOT the best' do
      let(:answer) { create(:answer, question: question, best_for: nil) }

      it 'returns false' do
        expect(question).to_not be_best(answer)
      end
    end
  end
end
