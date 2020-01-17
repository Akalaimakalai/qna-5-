class CommentsController < ApplicationController
  before_action :authenticate_user!

  authorize_resource

  def create
    @resource = find_resource
    @comment = @resource.comments.new(comment_params)
    @comment.save
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy if current_user.is_author?(@comment)
  end

  private

  def comment_params
    params[:comment].permit(:body).merge({ user_id: current_user.id })
  end

  def find_resource
    return Question.find(params[:question_id]) if params[:question_id]
    return Answer.find(params[:answer_id]) if params[:answer_id]
  end
end
