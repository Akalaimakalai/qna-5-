require 'rails_helper'

feature 'User can see his medals', %q{
  In order to see all my medals
  As an authenticated user
  I'd like to be able to see the list of medals
} do
  given(:user) { create(:user) }
  given!(:medals) { create_list(:medal, 2, user: user) }

  scenario 'user visit medal page' do
    sign_in(user)
    visit medals_path

    medals.each do |medal|
      expect(page).to have_content medal.question.title
      expect(page).to have_content medal.name
      expect(page).to have_css("img[src*='best_medal.png']")
    end
  end
end
