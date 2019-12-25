require 'rails_helper'

feature 'User can see rating of question/answer', %q{
  In order to estimate question/answer
  As an authenticated or unauthenticated user
  I'd like to be able to see rating of question/answer
}, js: true do

  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  scenario 'user click on a question' do
    visit questions_path
    click_on(question.title)

    within ".question#question-id-#{question.id}" do
      expect(page).to have_content('Score: 0')
    end

    within ".answer#answer-id-#{answer.id}" do
      expect(page).to have_content('Score: 0')
    end
  end
end
