# Пользователь может зарегистрироваться и войти в систему через сторонии провайдеры

require 'rails_helper'

feature 'User can log in through the third-party providers ', %q{
  In order to not invent a password
  As a registered or unregistered user
  i'd like to be able to sign up through the third-party providers
} do

  background { OmniAuth.config.test_mode = true }

  describe 'Registered user' do
    given!(:user) { create(:user) }
    given!(:authorization) { create(:authorization, user: user) }

    background do
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
                                                                    provider: 'authorization.provider',
                                                                    uid: authorization.uid,
                                                                    info: {
                                                                      email: user.email
                                                                    }
                                                                  })
    end

    scenario 'User want to log in through the third-party provider' do

      visit new_user_session_path

      click_on 'Sign in with GitHub'

      expect(page).to have_content(user.email)
      expect(page).to have_content('Successfully authenticated from GitHub account.')
    end
  end

  describe 'Unregistered user' do

    background do
      OmniAuth.config.mock_auth[:vkontakte] = OmniAuth::AuthHash.new({
                                                                      provider: 'vkontakte',
                                                                      uid: '123545',
                                                                      info: {
                                                                        email: "secrettest@gmail.com"
                                                                      }
                                                                    })
    end

    scenario 'User want to log in through the third-party provider' do

      visit new_user_session_path

      click_on 'Sign in with Vkontakte'

      open_email("secrettest@gmail.com")

      current_email.click_link 'Confirm my account'
      clear_emails

      expect(page).to have_content('Your email address has been successfully confirmed.')

      click_on 'Sign in with Vkontakte'

      expect(page).to have_content("secrettest@gmail.com")
      expect(page).to have_content('Successfully authenticated from Vkontakte account.')
    end
  end
end
