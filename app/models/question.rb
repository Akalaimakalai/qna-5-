class Question < ApplicationRecord
  belongs_to :user
  has_many :answers, dependent: :destroy
  has_one :best_answer, class_name: "Answer", foreign_key: 'best_for_id'

  validates :title, :body, presence: true

  attr_reader :answers_list, :var_best_answer

  def best?(answer)
    best_answer == answer
  end

  def sort_answers
    @answers_list = answers.sort_by { |a| a.created_at }

    @var_best_answer = best_answer

    if @var_best_answer
      @answers_list.delete(@var_best_answer)
      @answers_list.insert(0, @var_best_answer)
    end

    @answers_list
  end
end
