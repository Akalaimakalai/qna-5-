require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of the answer
  I'd like to be able to edit my answer
}, js: true do

  given!(:user) { create(:user) }
  given!(:user2) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Authenticated user' do

    context 'user is an author' do

      background do
        sign_in(user)
        visit question_path(question)
        click_on 'Edit'
      end

      scenario 'edit his answer' do
        within '.answers' do
          fill_in 'Your answer', with: 'edited answer'
          click_on 'Save'

          expect(page).to_not have_content(answer.body)
          expect(page).to have_content('edited answer')
          expect(page).to_not have_selector('textarea')
        end
      end

      scenario 'edit his answer with errors' do
        within '.answers' do
          fill_in 'Your answer', with: ''
          click_on 'Save'

          expect(page).to have_content(answer.body)
          expect(page).to have_content("Body can't be blank")
          expect(page).to have_selector('textarea')
        end
      end
    end

    context 'user is NOT an author' do
      background { sign_in(user2) }
      include_context 'can not edit answer'
    end
  end

  describe 'Unauthenticated user' do
    include_context 'can not edit answer'
  end
end
