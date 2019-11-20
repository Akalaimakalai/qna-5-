class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_answer, only: %i[ edit show update destroy best ]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.user_id = current_user.id
    @answer.save
  end

  def edit; end

  def show; end

  def update
    @question = @answer.question
    @answer.update(answer_params) if current_user.is_author?(@answer)
  end

  def destroy
    @answer.destroy if current_user.is_author?(@answer)
  end

  def best; end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end
end
