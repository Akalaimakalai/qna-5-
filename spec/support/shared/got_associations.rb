shared_examples_for 'Got associations' do
  let(:object_response) { json[object.class.name.underscore] }
  let(:list_of_has_many) { list_of_associations.select { |i| (i.last == 's') && (i != 'files') } }
  let(:list_of_has_one) { list_of_associations.select { |i| (i.last != 's') } }

  it 'returns all associations' do
    list_of_associations.each do |association|
      expect(object_response).to be_include(association)
    end
  end

  it 'returns files as url' do
    expect(object_response['files'].first['service_url']).to eq object.files.first.service_url
  end

  it 'returns correct objects with has_many' do
    list_of_has_many.each do |association|
      expect(object_response[association].first['id']).to eq object.send(association).first.id
    end
  end

  it 'returns correct objects with has_one, belongs_to' do
    list_of_has_one.each do |association|
      expect(object_response[association]['id']).to eq object.send(association).id
    end
  end
end
