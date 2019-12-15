require 'rails_helper'

feature 'User can vote a question', %q{
  In order to rate the question
  As an authenticated user
  I'd like to be able to vote for the question
}, js: true do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:question2) { create(:question, user: user) }

  describe 'Authenticated user' do

    background { sign_in(user) }

    describe 'user is NOT author' do

      background { visit question_path(question) }

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

    describe 'user is author' do
      scenario "user cannot vote the question" do
        visit question_path(question2)

        within '.question' do
          expect(page).to_not have_link("+")
          expect(page).to_not have_link("-")
        end
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
