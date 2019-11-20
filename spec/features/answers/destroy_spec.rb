require 'rails_helper'

feature 'Author can delete his answer', %q{
  In order to delete wrong answer
  As an author of this answer
  I'd like to be able to delete it
}, js: true do

  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user)}

  describe 'Authenticated user'do
    scenario 'deletes his answer' do
      sign_in(user)
      visit question_path(question)

      within '.answers' do
        expect(page).to have_content(answer.body)

        click_on 'Delete'

        expect(current_path).to eq question_path(question)
        expect(page).to_not have_content(answer.body)
      end
    end

    scenario "deletes someone's answer" do
      sign_in(user2)
      visit question_path(question)

      within '.answers' do
        expect(page).to have_content(answer.body)
        expect(page).to_not have_link('Delete')
      end
    end
  end

  describe 'Unuthenticated user' do
    scenario 'tries to delete an answer' do
      visit question_path(question)

      within '.answers' do
        expect(page).to have_content(answer.body)
        expect(page).to_not have_link('Delete')
      end
    end
  end
end
