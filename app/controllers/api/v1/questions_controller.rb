class Api::V1::QuestionsController < Api::V1::BaseController
  protect_from_forgery with: :null_session

  def index
    @questions = Question.all
    render json: @questions
    # При необходимости отрендерить объект другим сериалайзером
    # render json: @question, serializer: NameSerializer

    # При необходимости отрендерить коллекцию объектов другим сериалайзером
    # render json: @questions, each_serializer: NameSerializer
  end

  def show
    @question = Question.find(params[:id])
    render json: @question
  end

  def create
    @question = Question.new(question_params)
    @question.user_id = current_resource_owner.id
    @question.save!
    render json: @question, status: 201
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
