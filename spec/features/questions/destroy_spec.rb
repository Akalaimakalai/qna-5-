#  Автор может удалить свой вопрос, но не может удалить чужой

require 'rails_helper'

feature 'Author can delete his question', %q{
  In order to delete the question
  As an author of this question
  I'd like to be able to delete it
}, js: true do

  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given!(:question) { create(:question, user: user) }

  describe 'Authenticated user' do

    describe 'as an author' do
      scenario 'deletes the question' do
        sign_in(user)
        visit questions_path

        expect(page).to have_content(question.title)

        click_on 'Delete question'
        page.driver.browser.switch_to.alert.accept

        expect(page).to_not have_content(question.title)
      end
    end

    describe 'as NOT an author' do
      scenario 'tries to delete a question' do
        sign_in(user2)
        visit questions_path

        expect(page).to_not have_link('Delete question')
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'tries to delete a question' do
      visit questions_path

      expect(page).to_not have_link('Delete question')
    end
  end
end
