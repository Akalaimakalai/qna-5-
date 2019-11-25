class Question < ApplicationRecord
  belongs_to :user
  has_many :answers, dependent: :destroy

  validates :title, :body, presence: true

  def sort_answers
    answers.order(created_at: :asc).sort_by { |a| a.correct ? 0 : 1 }
  end
end
