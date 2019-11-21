class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  belongs_to :best_for, class_name: 'Question', optional: true

  validates :body, presence: true
end
