require 'rails_helper'

feature 'User can create question', %q{
  In order to get answer from the community
  As an authenticated user
  I'd like to be able to ask the question
}, js: true do

  given(:user) { create(:user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit questions_path
      click_on 'Ask question'
    end

    describe 'asks question with valid params' do

      background do
        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'text text text'
      end

      scenario 'without attached files' do
        click_on 'Ask'

        expect(page).to have_content 'Your question successfully created.'
        expect(page).to have_content 'Test question'
        expect(page).to have_content 'text text text'
      end

      scenario 'with attached files' do
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Ask'

        sleep(3)

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'asks a question with errors' do
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
    end
  end

  describe 'Unauthenticated user' do
    scenario 'tries asking a question' do
      visit questions_path

      expect(page).to_not have_button 'Ask question'
    end
  end

  describe 'Multiple sessions' do
    scenario "question appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path
      end

      Capybara.using_session('guest') do
        visit questions_path
        expect(page).to_not have_link 'Test question'
      end

      Capybara.using_session('user') do
        click_on 'Ask question'

        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'text text text'
        click_on 'Ask'

        expect(page).to have_content 'Your question successfully created.'
        expect(page).to have_content 'Test question'
        expect(page).to have_content 'text text text'
      end

      Capybara.using_session('guest') do
        expect(page).to have_link 'Test question'
      end
    end
  end
end
