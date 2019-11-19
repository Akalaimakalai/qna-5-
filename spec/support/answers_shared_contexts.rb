# ---Controller--

RSpec.shared_context 'declares user is unauthorized' do
  it 'declares user is unauthorized' do
    expect(response).to have_http_status(:unauthorized)
  end
end

RSpec.shared_context 'does not save the answer' do
  it 'does not save the answer' do
    expect{ post :create, params: params, format: :js }.to_not change(Answer, :count)
  end
end

RSpec.shared_context 'does not update the answer' do
  it 'does not update the answer' do
    answer.reload
    expect(answer.body).to eq "MyAnswerText"
    expect(answer.correct).to be_falsey
  end
end

RSpec.shared_context 'render template update' do
  it 'render template update' do
    expect(response).to render_template :update
  end
end

# ---Features---

RSpec.shared_context 'can not edit answer' do
  scenario 'can not edit answer' do
    visit question_path(question)
    expect(page).to_not have_link('Edit')
  end
end
