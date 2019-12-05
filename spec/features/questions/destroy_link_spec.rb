require 'rails_helper'

feature 'Author can delete any link from his question', %q{
  In order to delete useless links
  As an author of this answer
  I'd like to be able to delete a link
}, js: true do

  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:link) { create(:link, linkable: question) }

  describe 'Authenticated user' do

    describe 'as an author' do
      scenario 'deletes link from the question' do
        sign_in(user)
        visit question_path(question)

        within ".question-#{question.id}-links" do
          expect(page).to have_link('QNA', href: "http://localhost:3000/")

          click_on 'delete'

          expect(page).to_not have_link('QNA', href: "http://localhost:3000/")
        end
      end
    end

    describe 'as NOT an author' do
      scenario 'tries to delete link from the question' do
        sign_in(user2)
        visit question_path(question)

        within ".question-#{question.id}-links" do
          expect(page).to have_link('QNA', href: "http://localhost:3000/")
          expect(page).to_not have_link('delete')
        end
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'tries to delete link from the question' do
      visit question_path(question)

      within ".question-#{question.id}-links" do
        expect(page).to have_link('QNA', href: "http://localhost:3000/")
        expect(page).to_not have_link('delete')
      end
    end
  end
end
