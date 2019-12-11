require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an answr's author
  I'd like to be able to add links
}, js: true do
  given(:user) { create(:user) }
  given(:question) { create(:question)}
  given(:url) { 'https://google.ru/' }
  given(:gist_url) { 'https://gist.github.com/Akalaimakalai/52052829173db67ca71032268fd65e84' }

  scenario 'User adds link when asks answer' do
    sign_in(user)
    visit question_path(question)

    fill_in 'Body', with: 'text text text'

    fill_in 'Link name', with: 'Google'
    fill_in 'Url', with: url

    click_on 'Add answer'

    within '.answers' do
      expect(page).to have_link('Google', href: url)
    end
  end

  scenario 'User adds link to gist when asks answer' do
    sign_in(user)
    visit question_path(question)

    fill_in 'Body', with: 'text text text'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Add answer'

    within '.answers' do
      expect(page).to have_link('Hello Gist!', href: gist_url)
      expect(page).to have_content('Hello, world!')
    end
  end
end
