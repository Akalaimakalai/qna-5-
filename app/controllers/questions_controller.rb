class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[ index show ]
  before_action :load_question, only: %i[ show edit update destroy ]
  before_action :set_new_comment, only: %i[ show update ]

  authorize_resource

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answer.links.new

    gon.current_user_id = current_user&.id
    gon.question_id = @question.id
  end

  def new
    @question = Question.new
    @question.links.new
    @question.medal = Medal.new
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
    @question.update(question_params)
  end

  def destroy
    @question.destroy
    redirect_to questions_path
  end

  private

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [], links_attributes: [:name, :url, :_destroy, :id], medal_attributes: [:name, :image])
  end

  def set_new_comment
    @comment = Comment.new
  end
end
