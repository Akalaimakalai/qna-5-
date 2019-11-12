RSpec.shared_context 'does not change the question'do
  it 'does not change the question' do
    question = create(:question, title: "CheckTitle", body: "CheckBody")

    question.reload
    expect(question.title).to eq "CheckTitle"
    expect(question.body).to eq "CheckBody"
  end
end

RSpec.shared_context 'does not delete the question'do
  it 'does not delete the question' do
    expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
  end
end
