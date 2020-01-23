class Api::V1::AnswersController < Api::V1::BaseController
  before_action :find_answer, only: %i[ show update destroy ]

  def index
    @question = Question.find(params[:question_id])
    @answers = @question.answers
    render json: @answers
  end

  def show
    render json: @answer
  end

  def create
    @answer = current_resource_owner.answers.create!(answer_params.merge({ question_id: params[:question_id] }))
    render json: @answer, status: 201
  end

  def update
    @answer.update!(answer_params)
    render json: @answer
  end

  def destroy
    @answer.destroy
    head 204
  end

  private

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
