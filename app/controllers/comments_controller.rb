class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @comment = current_user.comments.new(comment_params)
    @comment.save
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy if current_user.is_author?(@comment)
  end

  private

  def comment_params
    params[:comment].permit(:commentable_type, :commentable_id, :body)
  end
end
