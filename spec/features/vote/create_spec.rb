require 'rails_helper'

feature 'User can vote for/against question/answer', %q{
  In order to rate the question/answer
  As an authenticated user
  I'd like to be able to vote for/against
}, js: true do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:user_question) { create(:question, user: user) }

  describe 'Authenticated user' do
    background { sign_in(user) }

    context 'is author of the record' do

      scenario 'cannot vote for himself' do
        visit question_path(user_question)

        within ".question#question-id-#{user_question.id}" do
          expect(page).to have_content('Score: 0')
          expect(page).to_not have_link('+')
          expect(page).to_not have_link('-')
        end
      end
    end

    context 'is NOT author of the record' do

      background { visit question_path(question) }

      scenario 'can vote and revote' do

        within ".question#question-id-#{question.id}" do
          expect(page).to have_content('Score: 0')
          expect(page).to have_link('+')
          expect(page).to have_link('-')

          click_on '+'

          expect(page).to have_content('Score: 1')

          click_on '-'

          expect(page).to have_content('Score: -1')
        end
      end

      scenario 'cannot vote twice' do

        within ".question#question-id-#{question.id}" do
          expect(page).to have_content('Score: 0')

          click_on '+'

          expect(page).to have_content('Score: 1')

          click_on '+'

          expect(page).to have_content('Score: 1')
        end

      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'cannot vote' do
      visit question_path(question)

      expect(page).to_not have_link('+')
      expect(page).to_not have_link('-')
    end
  end
end
