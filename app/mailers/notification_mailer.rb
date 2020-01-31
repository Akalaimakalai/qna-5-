class NotificationMailer < ApplicationMailer

  def new_answer(question, answer, user)
    @question = question
    @answer = answer
    @user = user
    mail to: @user.email
  end
end
