# При создании вопроса, пользователь может также создать награду за лучший ответ, которую получит отвечающий

require 'rails_helper'

feature 'User can add medal to question', %q{
  In order to reward the best answer's author
  As an question's author
  I'd like to be able to add medal
}, js: true do

  given(:user) { create(:user) }

  scenario 'User adds medal when asks question' do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Medal name', with: 'Test medal'
    attach_file 'Image', "/home/artur/Pictures/best_medal.png"

    click_on 'Ask'

    sleep(2)
    expect(page).to have_content 'Your question successfully created.'
  end
end
