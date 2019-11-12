#  Автор может удалить свой вопрос, но не может удалить чужой

require 'rails_helper'

feature 'Author can can delete his question', %q{
  In order to delete the question
  As an author of this question
  I'd like to be able to delete it
} do

  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'Authenticated user' do
    scenario 'Author tries deleting his question' do
      sign_in(user)
      visit question_path(question)

      expect(page).to have_content(question.title)

      click_on 'Delete question'

      expect(page).to_not have_content(question.title)
    end

    scenario 'User tries to delete a question' do
      sign_in(user2)
      visit question_path(question)

      expect(page).to_not have_content('Delete question')
    end
  end

  describe 'Unauthenticated user' do
    scenario 'tries to delete a question' do
      visit question_path(question)

      expect(page).to_not have_content('Delete question')
    end
  end
end
