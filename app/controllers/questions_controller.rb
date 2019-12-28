class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[ index show ]
  before_action :load_question, only: %i[ show edit update destroy ]

  after_action :publish_question, only: %i[ create ]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answer.links.new
    @comment = Comment.new
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

  private

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [], links_attributes: [:name, :url, :_destroy, :id], medal_attributes: [:name, :image])
  end

  def publish_question
    return if @question.errors.any?
    renderer = ApplicationController.renderer.new
    warden = request.env["warden"]
    renderer.instance_variable_set(:@env, {"HTTP_HOST"=>"localhost:3000", 
    "HTTPS"=>"off", 
    "REQUEST_METHOD"=>"GET", 
    "SCRIPT_NAME"=>"", 
    "warden" => warden})
    ActionCable.server.broadcast( 'questions',
                                  renderer.render(partial: 'questions/question',
                                                              locals: { question: @question }
                                                              )
                                  )
  end
end
