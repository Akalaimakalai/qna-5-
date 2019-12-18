class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_answer, only: %i[ edit show update destroy best ]
  before_action :set_question, only: %i[ update best ]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.user_id = current_user.id
    @answer.save
  end

  def edit; end

  def show; end

  def update
    @answer.update(answer_params) if current_user.is_author?(@answer)
  end

  def destroy
    @answer.destroy if current_user.is_author?(@answer)
  end

  def best
    @answer.set_correct if current_user.is_author?(@question)
    redirect_to question_path(@question)
  end

  private

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url, :_destroy, :id])
  end

  def set_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def set_question
    @question = @answer.question
  end
end
