class Api::V1::QuestionsController < Api::V1::BaseController
  protect_from_forgery with: :null_session

  before_action :find_question, only: %i[ show update destroy ]

  def index
    @questions = Question.all
    render json: @questions
    # При необходимости отрендерить объект другим сериалайзером
    # render json: @question, serializer: NameSerializer

    # При необходимости отрендерить коллекцию объектов другим сериалайзером
    # render json: @questions, each_serializer: NameSerializer
  end

  def show
    render json: @question
  end

  def create
    @question = Question.new(question_params)
    @question.user_id = current_resource_owner.id
    @question.save!
    render json: @question, status: 201
  end

  def update
    @question.update(question_params)
    render json: @question, status: 202
  end

  def destroy
    @question.destroy
    head 204
  end

  private

  def find_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
