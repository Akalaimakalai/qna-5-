class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_comment, only: %i[ destroy ]

  authorize_resource

  def create
    @resource = find_resource
    @comment = @resource.comments.new(comment_params)
    @comment.save
  end

  def destroy
    @comment.destroy
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params[:comment].permit(:body).merge({ user_id: current_user.id })
  end

  def find_resource
    return Question.find(params[:question_id]) if params[:question_id]
    return Answer.find(params[:answer_id]) if params[:answer_id]
  end
end
