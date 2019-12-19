class Answer < ApplicationRecord
  include Linkable
  include Votable

  belongs_to :question
  belongs_to :user

  has_many_attached :files

  validates :body, presence: true

  default_scope { order(correct: :desc).order(created_at: :asc) }

  def set_correct
    transaction do
      question.answers.update_all(correct: false)
      update!(correct: true)
      user.medals.push(question.medal) if question.medal
    end
  end
end
