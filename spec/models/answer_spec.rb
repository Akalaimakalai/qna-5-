require 'rails_helper'

RSpec.describe Answer, type: :model do
  include_examples "links"
  include_examples "votes", :answer
  include_examples "comments"

  it { should belong_to :question }
  it { should belong_to :user }

  it 'have many attached file' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  it { should validate_presence_of :body }

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }

  describe 'default scope' do
    let!(:answer3) { create(:answer, question: question) }
    let!(:answer2) { create(:answer, question: question, correct: true) }

    it 'sorts answrs by correct' do
      expect(question.answers).to eq [answer2, answer, answer3]
    end

    it 'sorts answrs by date' do
      expect(question.answers).to eq [answer2, answer, answer3]
    end
  end

  describe '#set_correct' do
    let!(:medal) { create(:medal, question: question) }

    before { answer.set_correct }

    context 'no correct answer before' do
      it 'set correct: true' do
        expect(answer).to be_correct
      end
    end

    context 'was correct answer before' do
      let!(:answer2) { create(:answer, question: question, correct: true) }

      it 'set answer2 correct: false' do
        answer.set_correct
        answer2.reload
        expect(answer2).to_not be_correct
      end

      it 'set answer correct: true' do
        expect(answer).to be_correct
      end
    end

    context 'question has medal' do
      it "adds medal to user's medals" do
        expect(user.medals.first).to eq medal
      end
    end
  end

  describe 'send_notification' do
    let!(:answer) { build(:answer) }
    let(:service) { double('NotificationService') }

    before do
      allow(NotificationService).to receive(:new).and_return(service)
    end

    it 'calls send_notification after creating new answer' do
      expect(answer).to receive(:send_notification)
      answer.save!
    end

    it 'calls NotificationService' do
      expect(service).to receive(:new_answer_for).with(answer.question)
      answer.save!
    end
  end
end
