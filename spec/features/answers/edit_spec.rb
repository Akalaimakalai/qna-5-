require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of the answer
  I'd like to be able to edit my answer
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Authenticated user' do

    scenario 'edit his answer' do
      # sign_in(user)
      # visit question_path(question)

      # click_on 'Edit'

      # within '.answers' do
      #   fill_in 'Your answer', with: 'edited answer'
      #   click_on 'Add answer'

      #   expect(page).to_not have_content(answer.body)
      #   expect(page).to have_content('edited answer')
      #   expect(page).to_not have_selector('textarea')
      # end
    end

    scenario 'edit his answer with errors'
    scenario "tries to edit someone's answer"
  end

  scenario 'Unauthenticated user can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link('Edit')
  end
end
