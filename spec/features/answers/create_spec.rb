# Пользователь, находясь на странице вопроса, может написать ответ на вопрос
# (т.е. форма нового ответа должна быть прямо на странице вопроса, без перехода на другую страницу)

require 'rails_helper'

feature 'User can write answer', %q{
  In order to answer the question
  As an authenticated user
  I'd like to be able to write an answer below the question
}, js: true do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'Authenticated user', js: true do

    background do
      sign_in(user)

      visit question_path(question)
    end

    describe 'adds answer with valid params' do
      background { fill_in 'Body', with: 'Answer text' }

      scenario 'without attached files' do
        expect(page).to_not have_content('Answer text')

        click_on 'Add answer'

        expect(current_path).to eq question_path(question)
        expect(page).to have_content(question.body)

        within '.answers' do
          expect(page).to have_content('Answer text')
        end
      end

      scenario 'with attached files' do
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

        click_on 'Add answer'

        sleep(3)

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'tries to add answer with invalid params' do
      fill_in 'Body', with: ''
      click_on 'Add answer'

      expect(page).to have_content(question.body)
      expect(page).to have_content("Body can't be blank")
    end
  end

  describe 'Unauthenticated user' do
    scenario 'tries to add answer' do
      visit question_path(question)

      expect(page).to_not have_content 'Body'
      expect(page).to_not have_button 'Add answer'
    end
  end

  describe 'Multiple sessions' do
    scenario "question appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
        expect(page).to_not have_content 'Answer text'
      end

      Capybara.using_session('user') do
        fill_in 'Body', with: 'Answer text'
        click_on 'Add answer'

        expect(current_path).to eq question_path(question)
        expect(page).to have_content(question.body)

        within '.answers' do
          expect(page).to have_content('Answer text')
        end
      end

      Capybara.using_session('guest') do
        within '.answers' do
          expect(page).to have_content('Answer text')
        end
      end
    end
  end
end
