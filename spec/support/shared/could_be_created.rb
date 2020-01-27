shared_examples_for 'Could be created' do
  let(:object_response) { json[klass.name.underscore] }

  it 'creates new object' do
    expect{ post api_path, params: params, headers: headers }.to change(klass, :count).by(1)
  end

  it 'sets current_resource_owner as author' do
    expect(object_response['user']['id']).to eq access_token.resource_owner_id
  end

  it 'renders new object' do
    hash_of_fields.each do |k, v|
      expect(object_response[k]).to eq v
    end
  end
end
