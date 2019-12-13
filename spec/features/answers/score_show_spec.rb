require 'rails_helper'

feature 'User can see score of a answer', %q{
  In order to value the question
  As an authenticated or unauthenticated user
  I'd like to be able to see answer rating
} do

  given(:question) { create(:question) }
  given!(:answer) {create(:answer, question: question) }

  scenario "user visit answer page" do
    visit question_path(question)

    within "#answer-id-#{answer.id}" do
      expect(page).to have_content("Score: 0")
    end
  end
end
