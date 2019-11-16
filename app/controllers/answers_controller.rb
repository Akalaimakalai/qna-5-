class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_answer, only: %i[ edit show update destroy ]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.user_id = current_user.id

    if @answer.save
      redirect_to @question
    else
      render 'questions/show'
    end
  end

  def edit; end

  def show; end

  def update
    if current_user.is_author?(@answer) && @answer.update(answer_params)
      redirect_to @answer
    else
      render :edit
    end
  end

  def destroy
    if current_user.is_author?(@answer)
      @answer.destroy
      redirect_to question_answers_path(@answer.question)
    else
      redirect_to @answer.question
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body, :correct)
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end
end
