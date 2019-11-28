class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  default_scope { order(correct: :desc).order(created_at: :asc) }

  def set_correct
    transaction do
      question.answers.update_all(correct: false)
      update!(correct: true)
    end
  end
end
