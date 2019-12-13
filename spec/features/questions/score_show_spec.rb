require 'rails_helper'

feature 'User can see score of a question', %q{
  In order to value the question
  As an authenticated or unauthenticated user
  I'd like to be able to see question rating
} do

  given(:question) { create(:question) }

  scenario "user visit question page" do
    visit question_path(question)

    within '.question' do
      expect(page).to have_content("Score: 0")
    end
  end
end
