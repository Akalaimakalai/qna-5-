require 'rails_helper'

feature 'User can revote', %q{
  In order to change my mind
  As an authenticated user
  I'd like to be able to revote
}, js: true do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user' do

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario "user revote for the question" do

      within '.question' do
        click_on '+'

        expect(page).to have_content("Score:1")

        click_on 'revote'

        expect(page).to have_content("Score:0")
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'cannot revote' do
      visit question_path(question)

      within '.question' do
        expect(page).to_not have_link("revote")
      end
    end
  end
end
