# Автор вопроса может выбрать лучший ответ для своего вопроса
# (лучший ответ может быть только 1)
# Автор вопроса может выбрать другой ответ как лучший, если у вопроса уже выбран лучший ответ
# (предыдущий лучший ответ перестает быть таковым)
# Если у вопроса выбран лучший ответ, то он отображается первым в списке ответов.

require 'rails_helper'

feature 'User can choose the best answer', %q{
  In order to choose the correct answer
  As an author of the question
  I'd like to be able to choose the best answer
}, js: true do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Authenticated user' do

    context 'user is an author' do

      context 'there is no the best answer before' do

        scenario 'user choose the best answer' do

          sign_in(user)
          visit question_path(question)

          within "#answer-id-#{answer.id}" do
            expect(page).to_not have_content 'THE BEST!'
          end

          click_on 'Correct'

          within "#answer-id-#{answer.id}" do
            expect(page).to have_content 'THE BEST!'
          end
        end
      end

      context 'the best answer already exist' do
        given!(:answer2) { create(:answer, question: question, user: user, correct: true) }

        scenario 'user choose another answer as the best' do

          sign_in(user)
          visit question_path(question)

          within "#answer-id-#{answer.id}" do
            expect(page).to_not have_content 'THE BEST!'
          end

          within "#answer-id-#{answer2.id}" do
            expect(page).to have_content 'THE BEST!'
          end

          click_on 'Correct'

          within "#answer-id-#{answer.id}" do
            expect(page).to have_content 'THE BEST!'
          end

          within "#answer-id-#{answer2.id}" do
            expect(page).to_not have_content 'THE BEST!'
          end
        end
      end
    end

    context 'user is NOT an author' do

      given(:user2) { create(:user) }

      background do
        sign_in(user2)
        visit question_path(question)
      end

      scenario 'user can not choose the best one' do
        within '.answers' do
          expect(page).to_not have_button 'Correct'
        end
      end
    end
  end

  describe 'Unauthenticated user' do
    given(:answer2) { create(:answer, question: question, user: user, correct: true) }

    scenario 'user can not choose the best one' do
      visit question_path(question)

      within '.answers' do
        expect(page).to_not have_button 'Correct'
      end
    end
  end

  describe 'List tests' do
    scenario 'the best answer is the first in the list' do
      answer2 = create(:answer, question: question, user: user, correct: true)

      sign_in(user)
      visit question_path(question)

      expect(first('.answer')).to have_content("THE BEST!")
    end

    scenario 'answers were sorted by date' do
      answer2 = create(:answer, question: question, user: user, created_at: 1.day.ago)

      sign_in(user)
      visit question_path(question)

      expect(first('.answer')).to have_content(answer2.body)
    end
  end
end
