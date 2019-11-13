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
    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end
