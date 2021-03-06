require 'rails_helper'

feature 'User can see the list of questions', %q{
  In order to find the question that I need
  As an authenticated or unauthenticated user
  I'd like to be able to see the list of questions
} do
  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 2, user: user) }

  scenario 'user visit root page' do
    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.title
    end
  end
end
