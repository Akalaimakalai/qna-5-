RSpec.shared_context 'does not update the answer'do
  it 'does not update the answer' do
    answer.reload
    expect(answer.body).to eq "MyAnswerText"
    expect(answer.correct).to be_falsey
  end
end

RSpec.shared_context 'does not save the answer'do
  it 'does not save the answer' do
    expect{ post :create, params: params, format: :js }.to_not change(Answer, :count)
  end
end
