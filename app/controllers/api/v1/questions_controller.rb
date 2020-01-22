class Api::V1::QuestionsController < Api::V1::BaseController

  def index
    @questions = Question.all
    render json: @questions
    # При необходимости отрендерить объект другим сериалайзером
    # render json: @question, serializer: :serializer_name

    # При необходимости отрендерить коллекцию объектов другим сериалайзером
    # render json: @questions, each_serializer: :serializer_name
  end
end
