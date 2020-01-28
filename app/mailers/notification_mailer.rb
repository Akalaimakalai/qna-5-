class NotificationMailer < ApplicationMailer

  def new_answer(question, user)
    @question = question
    @user = user
    mail to: @user.email
  end
end
