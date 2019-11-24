class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[ index show ]
  before_action :load_question, only: %i[ show edit update destroy ]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
  end

  def new
    @question = Question.new
  end

  def edit; end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    @question.update(question_params) if current_user.is_author?(@question)
  end

  def destroy
    if current_user.is_author?(@question)
      @question.destroy
      redirect_to questions_path
    else
      redirect_to @question, alert: 'You must be an author of the question to delete it.'
    end
  end

  # def best
  #   if current_user.is_author?(@question)
  #     @answer = Answer.find(params[:answer_id])
  #     @question.best_answer = @answer if @answer.question_id == @question.id
  #     @question.save
  #   end

  #   redirect_to question_path(@question)
  # end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
