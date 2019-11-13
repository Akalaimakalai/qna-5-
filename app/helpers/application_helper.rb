module ApplicationHelper
  def user_is_author?
    user_signed_in? && (@question.is_author?(current_user))
  end
end
