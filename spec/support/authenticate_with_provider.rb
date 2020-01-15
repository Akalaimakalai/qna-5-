RSpec.shared_examples "authenticate_with_provider" do |provider_name|
  let(:oauth_data) { { 'provider' => provider_name.to_s, 'uid' => 123 } }

  context 'user exists' do
    let!(:user) { create(:user) }

    before do
      allow(User).to receive(:find_for_oauth).and_return(user)
      get provider_name
    end

    it 'login user' do
      expect(subject.current_user).to eq user
    end

    it 'redirects to root path' do
      expect(response).to redirect_to root_path
    end
  end

  context 'user does not exists' do

    before do
      allow(User).to receive(:find_for_oauth)
      get provider_name
    end

    it 'redirects to root path' do
      expect(response).to redirect_to root_path
    end

    it 'does not login user' do
      expect(subject.current_user).to_not be
    end
  end
end
