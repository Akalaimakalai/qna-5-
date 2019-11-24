class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  # belongs_to :best_for, class_name: 'Question', optional: true

  validates :body, presence: true
  # validate :validate_answer_cannot_be_best_for_alien_question, if: :best_for

  # private

  # def validate_answer_cannot_be_best_for_alien_question
  #   if (question != best_for)
  #     errors.add(:answer, "Can't be set as the best for alien question")
  #   end
  # end
end
