# Пользователь может выйти из системы

require 'rails_helper'

feature 'User can sign out', %q{
  In order to change acc
  As an authenticated User
  i'd like to be able to sign out
} do

  given(:user) { create(:user) }

  describe 'Authenticated user' do
    scenario 'tries to sign out' do
      sign_in(user)

      visit questions_path
      click_on 'Exit'

      expect(page).to have_content('Signed out successfully.')
    end
  end

  describe 'Unauthenticated user' do
    scenario 'tries to sign out' do
      visit questions_path
      expect(page).to_not have_link('Exit')
    end
  end
end
