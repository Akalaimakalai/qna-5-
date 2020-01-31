require 'rails_helper'

feature 'User can unsubscribe question', %q{
  In order to don't get news about new answers anymore
  As a follower
  I'd like to be able to stop following the question
}, js: true do

  given(:user) { create(:user) }
  given(:user_question) { create(:question, user: user) }
  given(:question) { create(:question) }

  describe 'Authenticated user' do

    background do
      sign_in(user)
    end

    describe 'is already following question' do

      scenario "wants to unsubscribe" do
        visit question_path(user_question)

        within '.question' do

          click_on "Stop following"

          expect(page).to_not have_button('Stop following')
          expect(page).to have_button('Follow')
        end
      end
    end

    describe 'is NOT following question yet' do

      scenario "visits question_path and sees 'Follow' button" do
        visit question_path(question)

        within '.question' do
          expect(page).to_not have_button('Stop following')
          expect(page).to have_button('Follow')
        end
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'visits question_path and sees no message, no button' do
      visit question_path(user_question)

      within '.question' do
        expect(page).to_not have_button('Stop following')
        expect(page).to_not have_button('Follow')
      end
    end
  end
end
