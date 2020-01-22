class Api::V1::QuestionsController < Api::V1::BaseController

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
end
