require 'sphinx_helper'

feature 'User can search', %q{
  In order to find something
  As an authenticated or unauthenticated user
  I'd like to be able to search in all categories
}, js: true do
  given!(:question) { create(:question, title: 'test question') }
  given!(:answer) { create(:answer, body: 'test answer') }
  given!(:comment) { create(:comment, commentable: question, body: 'test comment') }
  given!(:user) { create(:user, email: 'test@mail.com') }

  background { visit root_path }

  describe 'User searches with valid value' do
    scenario 'in all categories', sphinx: true do

      ThinkingSphinx::Test.run do
        fill_in 'Search for:', with: 'test'
        click_on 'search'

        expect(page).to have_content('test question')
        expect(page).to have_content('test answer')
        expect(page).to have_content('test comment')
        expect(page).to have_content('test@mail.com')
      end
    end

    scenario 'in Question', sphinx: true do

      ThinkingSphinx::Test.run do
        select "Вопросы", from: "classes"
        fill_in 'Search for:', with: 'test'
        click_on 'search'

        expect(page).to have_content('test question')
        expect(page).to_not have_content('test answer')
        expect(page).to_not have_content('test comment')
        expect(page).to_not have_content('test@mail.com')
      end
    end

    scenario 'in Answer', sphinx: true do

      ThinkingSphinx::Test.run do
        select "Ответы", from: "classes"
        fill_in 'Search for:', with: 'test'
        click_on 'search'

        expect(page).to_not have_content('test question')
        expect(page).to have_content('test answer')
        expect(page).to_not have_content('test comment')
        expect(page).to_not have_content('test@mail.com')
      end
    end

    scenario 'in Comment', sphinx: true do

      ThinkingSphinx::Test.run do
        select "Комментарии", from: "classes"
        fill_in 'Search for:', with: 'test'
        click_on 'search'

        expect(page).to_not have_content('test question')
        expect(page).to_not have_content('test answer')
        expect(page).to have_content('test comment')
        expect(page).to_not have_content('test@mail.com')
      end
    end

    scenario 'in User', sphinx: true do

      ThinkingSphinx::Test.run do
        select "Пользователи", from: "classes"
        fill_in 'Search for:', with: 'test'
        click_on 'search'

        expect(page).to_not have_content('test question')
        expect(page).to_not have_content('test answer')
        expect(page).to_not have_content('test comment')
        expect(page).to have_content('test@mail.com')
      end
    end
  end

  describe 'User searches with invalid value' do
    scenario 'in all categories', sphinx: true do

      ThinkingSphinx::Test.run do
        fill_in 'Search for:', with: 'Happiness'
        click_on 'search'

        expect(page).to_not have_content('test question')
        expect(page).to_not have_content('test answer')
        expect(page).to_not have_content('test comment')
        expect(page).to_not have_content('test@mail.com')
        expect(page).to have_content('No matches')
      end
    end
  end
end
