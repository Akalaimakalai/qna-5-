require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of the answer
  I'd like to be able to edit my answer
}, js: true do

  given!(:user) { create(:user) }
  given!(:user2) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Authenticated user' do

    context 'user is an author' do

      background do
        sign_in(user)
        visit question_path(question)
        click_on 'Edit'
      end

      scenario 'edit his answer' do
        within '.answers' do
          fill_in 'Your answer', with: 'edited answer'
          click_on 'Save'

          expect(page).to_not have_content(answer.body)
          expect(page).to have_content('edited answer')
          expect(page).to_not have_selector('textarea')
        end
      end

      scenario 'edit his answer with adding files' do

        within "#answer-id-#{answer.id}" do
          fill_in 'Your answer', with: 'edited answer'

          attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

          click_on 'Save'
        end

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end

      scenario 'edit his answer with adding links' do

        expect(page).to_not have_link('Yandex', href: 'http://yandex.ru/')
        expect(page).to_not have_link('Google', href: 'http://google.ru/')

        within "#answer-id-#{answer.id}" do
          fill_in 'Your answer', with: 'edited answer'

          click_on 'add link'

          fill_in 'Link name', with: 'Yandex'
          fill_in 'Url', with: 'http://yandex.ru/'

          click_on 'add link'

          within all('.nested-fields')[1] do
            fill_in 'Link name', with: 'Google'
            fill_in 'Url', with: 'http://google.ru/'
          end

          click_on 'Save'
        end

        expect(page).to have_link('Yandex', href: 'http://yandex.ru/')
        expect(page).to have_link('Google', href: 'http://google.ru/')
      end

      scenario 'edit his answer with errors' do
        within '.answers' do
          fill_in 'Your answer', with: ''
          click_on 'Save'

          expect(page).to have_content(answer.body)
          expect(page).to have_content("Body can't be blank")
          expect(page).to have_selector('textarea')
        end
      end
    end

    context 'user is NOT an author' do
      background { sign_in(user2) }

      scenario 'can not edit an answer' do
        visit question_path(question)
        expect(page).to_not have_link('Edit')
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'can not edit an answer' do
      visit question_path(question)
      expect(page).to_not have_link('Edit')
    end
  end
end
