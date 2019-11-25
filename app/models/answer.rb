class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  def set_correct
    question.answers.where(correct: true).update_all(correct: false) unless question.answers.where(correct: true).empty?
    update(correct: true)
  end
end
