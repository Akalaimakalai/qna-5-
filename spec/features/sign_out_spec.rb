# Пользователь может выйти из системы

require 'rails_helper'

feature 'User can sign out', %q{
  In order to change acc
  As an authenticated User
  i'd like to be able to sign out
} do

  given(:user) { create(:user) }

  scenario 'user tries to sign out' do
    sign_in(user)

    visit questions_path
    click_on 'Exit'

    expect(page).to have_content('Signed out successfully.')
  end
end
