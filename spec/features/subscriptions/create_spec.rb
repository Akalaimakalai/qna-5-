require 'rails_helper'

feature 'User can subscribe to question', %q{
  In order to get news about new answers
  As an authenticated user
  I'd like to be able to follow the question
}, js: true do

  given(:user) { create(:user) }
  given(:user_question) { create(:question, user: user) }
  given(:question) { create(:question) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
    end

    describe 'is already following question' do

      scenario "visits question_path and sees 'Stop following' botton" do
        visit question_path(user_question)

        within '.question' do
          expect(page).to have_button('Stop following')
          expect(page).to_not have_button('Follow')
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

      scenario 'want to start following' do
        visit question_path(question)

        within '.question' do
          click_on 'Follow'

          expect(page).to have_button('Stop following')
          expect(page).to_not have_button('Follow')
        end
      end
    end
  end

  describe 'Unauthenticated user' do

    scenario 'visits question_path and sees no button' do
      visit question_path(user_question)

      within '.question' do
        expect(page).to_not have_button('Stop following')
        expect(page).to_not have_button('Follow')
      end
    end
  end
end
