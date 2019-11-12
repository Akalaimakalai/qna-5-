class AnswersController < ApplicationController
  before_action :set_answer, only: %i[ edit show update destroy ]

  def index
    @answers = Question.find(params[:question_id]).answers
  end

  def create
    @answer = Answer.new(answer_params)

    if @answer.save
      redirect_to @answer
    else
      render :new
    end
  end

  def new
    @answer = Answer.new
  end

  def edit; end

  def show; end

  def update
    if @answer.update(answer_params)
      redirect_to @answer
    else
      render :edit
    end
  end

  def destroy
    @answer.destroy
    redirect_to question_answers_path(@answer.question)
  end

  private

  def answer_params
    params.require(:answer).permit(:body, :correct, :question_id)
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end
end
