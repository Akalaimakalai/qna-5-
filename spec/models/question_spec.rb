require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  # it { should have_one(:best_answer) }
  it { should belong_to :user }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  describe '#sort_answers' do
    let(:question) { create(:question) }
    let!(:answer1) { create(:answer, question: question, created_at: Time.now) }
    let!(:answer2) { create(:answer, question: question, created_at: Time.now + 100) }
    let!(:answer3) { create(:answer, question: question, created_at: Time.now - 100) }

    context 'if best answer presents' do
      let!(:answer) { create(:answer, question: question, correct: true, created_at: Time.now + 300) }

      it 'it return list of answers sorteted with best - first' do
        expect(question.sort_answers).to eq [answer, answer3, answer1, answer2]
      end
    end

    context 'if is no best answer here' do
      it 'return sorted list of answrs sorted by created date' do
        expect(question.sort_answers).to eq [answer3, answer1, answer2]
      end
    end
  end

  # describe '#best?' do
  #   let(:question) { create(:question) }

  #   context 'answer is the best' do
  #     let(:answer) { create(:answer, question: question, best_for: question) }

  #     it 'returns true' do
  #       expect(question).to be_best(answer)
  #     end
  #   end

  #   context 'answer is NOT the best' do
  #     let(:answer) { create(:answer, question: question, best_for: nil) }

  #     it 'returns false' do
  #       expect(question).to_not be_best(answer)
  #     end
  #   end
  # end

  # describe '#sort_answers' do
  #   let(:question) { create(:question) }
  #   let!(:answer2) { create(:answer, question: question, created_at: Time.now + 100)}
  #   let!(:answer1) { create(:answer, question: question, created_at: Time.now)}

  #   context 'if best answer presents' do
  #     let!(:answer) {create(:answer, question: question, best_for: question, created_at: Time.now + 300)}

  #     it 'it return list of answers sorteted with best - first' do
  #       question.sort_answers
  #       expect(question.answers_list.first).to eq answer
  #     end
  #   end

  #   context 'if is no best answer here' do
  #     it 'return sorted list of answrs sorted by created date' do
  #       question.sort_answers
  #       expect(question.answers_list.first).to eq answer1
  #     end
  #   end
  # end
end
