require "rails_helper"

RSpec.describe NotificationMailer, type: :mailer do

  describe '#new_answer(question, answer, user)' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, created_at: Time.zone.now - 1000) }
    let(:answer) { build(:answer, question: question) }
    let(:mail) { NotificationMailer.new_answer(question, answer, user).deliver_now }

    it 'renders the subject' do
      expect(mail.subject).to eq('New answer')
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([user.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(["from@example.com"])
    end
  end
end
