class Question < ApplicationRecord
  belongs_to :user
  has_many :answers, dependent: :destroy
  has_one :best_answer, class_name: "Answer", foreign_key: 'best_for_id'

  validates :title, :body, presence: true
end
