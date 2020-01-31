require "rails_helper"

RSpec.describe DailyDigestMailer, type: :mailer do

  describe '#digest(user)' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, created_at: 1.hour.ago) }
    let(:mail) { DailyDigestMailer.digest(user).deliver_now }

    it 'renders the subject' do
      expect(mail.subject).to eq('Digest')
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([user.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(["from@example.com"])
    end
  end
end
