shared_examples_for 'List of answers' do
  it 'returns list of answers' do
    expect(answers_response.size).to eq answers.size
  end

  context 'every answer' do
    it_behaves_like 'Public object' do
      let(:object) { answers.first }
      let(:public_fields) { %w[ id body created_at updated_at ] }
      let(:response_object) { answers_response.first }
    end
  end
end
