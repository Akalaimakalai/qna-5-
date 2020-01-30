require 'rails_helper'

RSpec.describe NotificationService do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question)}
  let(:user) { question.user }
  let(:user2) { create(:user) }

  it 'sends notification to all followers' do
    question.followers.each { |user| expect(NotificationMailer).to receive(:new_answer).with(question, answer, user).and_call_original }
    expect(NotificationMailer).to_not receive(:new_answer).with(question, answer, user2)
    NotificationService.new_answer_for(question, answer)
  end
end
