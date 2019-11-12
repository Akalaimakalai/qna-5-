# Пользователь может зарегистрироваться в системе

require 'rails_helper'

feature 'User can sign up', %q{
  In order to become a registered user
  As an unregistered user
  i'd like to be able to sign up
} do

  background { visit new_user_registration_path }

  scenario 'user tries to sign up' do
    fill_in 'Email', with: 'user@test.xxx'
    fill_in 'Password', with: 'qwerty'
    fill_in 'Password confirmation', with: 'qwerty'
    click_on 'Sign up'

    expect(page).to have_content('Welcome! You have signed up successfully.')
  end
end
