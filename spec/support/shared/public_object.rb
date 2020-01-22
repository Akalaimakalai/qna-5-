shared_examples_for 'Public object' do
  it 'returns all public fields' do
    public_fields.each do |attr|
      expect(response_object[attr]).to eq object.send(attr).as_json
    end
  end
end
