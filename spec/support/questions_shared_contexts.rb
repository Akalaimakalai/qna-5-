RSpec.shared_context 'does not change the question' do
  it 'does not change the question' do
    question2.reload

    expect(question2.title).to eq 'CheckTitle'
    expect(question2.body).to eq 'CheckBody'
  end
end

RSpec.shared_context 'does not delete the question'do
  it 'does not delete the question' do
    expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
  end
end
