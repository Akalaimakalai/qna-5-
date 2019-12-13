class Answer < ApplicationRecord
  include Linkable

  after_save :create_score

  belongs_to :question
  belongs_to :user

  has_many_attached :files
  has_one :score, dependent: :destroy, as: :scorable

  validates :body, presence: true

  default_scope { order(correct: :desc).order(created_at: :asc) }

  def set_correct
    transaction do
      question.answers.update_all(correct: false)
      update!(correct: true)
      user.medals.push(question.medal) if question.medal
    end
  end

  private

  def create_score
    Score.create!(author: user, scorable_type: "Answer", scorable_id: id)
  end
end
