require 'rails_helper'

RSpec.describe DailyDigestService do
  let(:users) { create_list(:user, 3) }

  context 'was created question for the past day' do
    let!(:question) { create(:question, user: users.first, created_at: 1.day.ago)}

    it 'sends daily digest to all users' do
      users.each { |user| expect(DailyDigestMailer).to receive(:digest).with(user).and_call_original }
      DailyDigestService.send_digest
    end
  end

  context 'was no questions for the past day' do

    it 'does not call DailyDigestMailer' do
      users.each { |user| expect(DailyDigestMailer).to_not receive(:digest) }
      DailyDigestService.send_digest
    end
  end
end
