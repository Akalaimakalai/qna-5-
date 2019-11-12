require 'rails_helper'

feature 'User can see the question and answers for it', %q{
  In order to find the answer for my question
  As an authenticated or unauthenticated user
  I'd like to be able to see the question and answers for it
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 3, question: question) }

  scenario 'user click on a question' do
    visit questions_path
    click_on(question.title)

    expect(page).to have_content(question.title)
    expect(page).to have_content(answers[0].body)
    expect(page).to have_content(answers[1].body)
    expect(page).to have_content(answers[2].body)
  end
end
