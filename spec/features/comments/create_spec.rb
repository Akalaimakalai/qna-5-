require 'rails_helper'

feature 'User can write comment', %q{
  In order to add something or ask
  As an authenticated user
  I'd like to be able to write a comments
}, js: true do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit question_path(question)
      click_on 'add comment'
    end

    scenario 'add comment with valid params' do

      expect(page).to_not have_content 'Test comment'

      fill_in 'Your comment', with: 'Test comment'

      click_on 'comment'

      within '.question' do
        within '.comments' do
          expect(page).to have_content 'Test comment'
        end
      end
    end

    scenario 'add comment with invalid params' do
      fill_in 'Your comment', with: ''

      click_on 'comment'
      within '.question' do
        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'tries add comment' do
      visit question_path(question)

      expect(page).to_not have_link 'add comment'
    end
  end

  describe 'Multiple sessions' do
    scenario "comment appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
        expect(page).to_not have_content 'Test comment'
      end

      Capybara.using_session('user') do
        click_on 'add comment'

        fill_in 'Your comment', with: 'Test comment'

        click_on 'comment'

        within '.question' do
          within '.comments' do
            expect(page).to have_content 'Test comment'
          end
        end
      end

      Capybara.using_session('guest') do
        within '.question' do
          within '.comments' do
            expect(page).to have_content 'Test comment'
          end
        end
      end
    end
  end
end
