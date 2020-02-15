class Comment < ApplicationRecord
  after_create_commit :broadcast_comment

  belongs_to :user
  belongs_to :commentable, polymorphic: true, touch: true

  validates :body, presence: true

  default_scope { order(created_at: :asc) }

  private

  def broadcast_comment
    ActionCable.server.broadcast("comments-#{comment_data[:question_id]}", data: comment_data)
  end

  def comment_data
    {
      comment: self,
      question_id: commentable.is_a?(Question) ? commentable.id : commentable.question_id,
      commentable_id: commentable_id,
      commentable_type: commentable_type,
      commentable_type_down: commentable_type.downcase
    }
  end
end
