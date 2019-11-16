RSpec.shared_context 'Redirects to sing in'do
  it 'redirects to sing in' do
    expect(response).to redirect_to new_user_session_path
  end
end
