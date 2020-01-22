shared_examples_for 'List of answers' do
  it 'returns list of answers' do
    expect(answers_response.size).to eq answers.size
  end

  it 'returns all public fields' do
    %w[ id body created_at updated_at ].each do |attr|
      expect(answers_response.first[attr]).to eq answers.first.send(attr).as_json
    end
  end
end
