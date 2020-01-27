shared_examples_for 'Could be updated' do
  let(:object_response) { json[object.class.name.underscore] }

  it 'renders changed object' do
    hash_of_fields.each do |k, v|
      expect(object_response[k]).to eq v
    end
  end
end
