require 'rails_helper'

feature 'Author can delete his comment', %q{
  In order to delete the comment
  As an author of this comment
  I'd like to be able to delete it
}, js: true do

  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:comment) { create(:comment, commentable: question, user: user) }

  describe 'Authenticated user' do

    describe 'as an author' do
      scenario 'deletes comment' do
        sign_in(user)
        visit question_path(question)

        within '.question' do
          within '.comments' do
            expect(page).to have_content('TestComment')

            click_on 'delete'

            expect(page).to_not have_content('TestComment')
          end
        end
      end
    end

    describe 'as NOT an author' do
      scenario 'cannot delete comment' do
        sign_in(user2)
        visit question_path(question)

        within '.question' do
          within '.comments' do
            expect(page).to have_content('TestComment')
            expect(page).to_not have_link('delete')
          end
        end
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'cannot delete a comment' do
      visit question_path(question)

      within '.question' do
        within '.comments' do
          expect(page).to have_content('TestComment')
          expect(page).to_not have_link('delete')
        end
      end
    end
  end
end
