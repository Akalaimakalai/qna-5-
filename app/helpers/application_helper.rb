module ApplicationHelper
  def user_is_author?
    user_signed_in? && (current_user == @question.user)
  end
end
