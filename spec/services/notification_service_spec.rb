require 'rails_helper'

RSpec.describe NotificationService do
  let(:question) { create(:question) }

  it 'sends notification to all followers' do
    question.followers.each { |user| expect(NotificationMailer).to receive(:new_answer).with(question, user).and_call_original }
    subject.new_answer_for(question)
  end
end
