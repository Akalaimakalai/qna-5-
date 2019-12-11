# Автор ответа может удалить любой из прикрепленных к своему ответу файлов

require 'rails_helper'

feature 'Author can delete any file from his answer', %q{
  In order to delete useless files
  As an author of this answer
  I'd like to be able to delete a file
}, js: true do

  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer_with_file) { create(:answer, :with_file, question: question, user: user) }

  describe 'Authenticated user' do

    describe 'as an author' do
      scenario 'deletes file from the answer' do

        sign_in(user)
        visit question_path(question)

        within ".answer-#{answer_with_file.id}-files" do
          expect(page).to have_link('rails_helper.rb')

          click_on 'delete'

          expect(page).to_not have_link('rails_helper.rb')
        end
      end
    end

    describe 'as NOT an author' do
      scenario 'tries to delete file from the answer' do
        sign_in(user2)
        visit question_path(question)

        within ".answer-#{answer_with_file.id}-files" do
          expect(page).to have_link('rails_helper.rb')
          expect(page).to_not have_link('delete')
        end
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'tries to delete file from the answer' do
      visit question_path(question)

      within ".answer-#{answer_with_file.id}-files" do
        expect(page).to have_link('rails_helper.rb')
        expect(page).to_not have_link('delete')
      end
    end
  end
end
