shared_examples_for 'API Authorizable' do

  context 'unauthorized' do
    it 'returns 401 status and empty body if there is no access_token' do
      do_request(method, api_path, headers: headers)
      expect(response.body).to be_empty
      expect(response.status).to eq 401
    end

    it 'returns 401 status and empty body if access_token is invalid' do
      do_request(method, api_path, params: { access_token: '1234' }, headers: headers)
      expect(response.body).to be_empty
      expect(response.status).to eq 401
    end
  end
end
