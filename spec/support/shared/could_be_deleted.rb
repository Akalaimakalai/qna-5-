shared_examples_for 'Could be deleted' do

  it 'destroys object' do
    expect{
            delete api_path,
            params: { access_token: access_token.token },
            headers: headers
          }.to change(klass, :count).by(-1)
    expect(response.status).to eq 204
  end
end
