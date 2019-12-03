require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of the question
  I'd like to be able to edit my question
}, js: true do

  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'Authenticated user'do

    context 'user is an author' do

      background do
        sign_in(user)
        visit question_path(question)
        click_on 'Edit question'
      end

      scenario 'edit his question' do
        fill_in 'Title', with: 'MyNewTitle'
        fill_in 'Your question', with: 'MyNewBody'
        click_on 'Save'

        expect(current_path).to eq question_path(question)
        expect(page).to_not have_content(question.body)
        expect(page).to have_content('MyNewTitle')
        expect(page).to have_content('MyNewBody')
      end

      scenario 'edit his question with adding files' do

        within "#edit-question-#{question.id}" do
          fill_in 'Title', with: 'MyNewTitle'
          fill_in 'Your question', with: 'MyNewBody'

          attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

          click_on 'Save'
        end

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end

      scenario 'edit his question with errors' do
        fill_in 'Title', with: ''
        fill_in 'Your question', with: ''
        click_on 'Save'

        expect(current_path).to eq question_path(question)
        expect(page).to have_content("Body can't be blank")
        expect(page).to have_content("Title can't be blank")
      end
    end

    context 'user is NOT an author' do
      before { sign_in(user2) }

      scenario 'can not edit a question' do
        visit question_path(question)
        expect(page).to_not have_link('Edit question')
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'can not edit a question' do
      visit question_path(question)
      expect(page).to_not have_link('Edit question')
    end
  end
end
