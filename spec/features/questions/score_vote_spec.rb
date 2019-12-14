require 'rails_helper'

feature 'User can vote a question', %q{
  In order to rate the question
  As an authenticated user
  I'd like to be able to vote for the question
}, js: true do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user' do

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario "user vote for the question" do
      within '.question' do
        expect(page).to have_content("Score: 0")

        click_on '+'

        expect(page).to have_content("Score: 1")
      end
    end

    scenario "user vote against the question" do
      within '.question' do
        expect(page).to have_content("Score: 0")

        click_on '-'

        expect(page).to have_content("Score: -1")
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'cannot vote for/against the question' do
      visit question_path(question)

      within '.question' do
        expect(page).to_not have_link("+")
        expect(page).to_not have_link("-")
      end
    end
  end
end
