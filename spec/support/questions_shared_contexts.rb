# ---Controller---

RSpec.shared_context 'does not change the question' do
  it 'does not change the question' do
    question2.reload

    expect(question2.title).to eq 'CheckTitle'
    expect(question2.body).to eq 'CheckBody'
  end
end

RSpec.shared_context 'does not delete the question' do
  it 'does not delete the question' do
    expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
  end
end

# ---Features---

RSpec.shared_context 'can not edit a question' do
  scenario 'can not edit a question' do
    visit question_path(question)
    expect(page).to_not have_link('Edit question')
  end
end
