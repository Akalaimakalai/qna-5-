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

# RSpec.shared_context 'does not set answer as the best' do
#   it 'does not set answer as the best' do
#     expect(question.best_answer).to_not eq answer
#   end
# end

RSpec.shared_context 'redirect to @question' do
  it 'redirect to @question' do
    expect(response).to redirect_to question_path(question)
  end
end

RSpec.shared_context 'has to prove that user is NOT an author' do
  it 'has to prove that user is NOT an author' do
    expect(user2).to_not be_is_author(question)
  end
end

# ---Features---

RSpec.shared_context 'can not edit a question' do
  scenario 'can not edit a question' do
    visit question_path(question)
    expect(page).to_not have_link('Edit question')
  end
end
