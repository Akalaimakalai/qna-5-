class NotificationMailer < ApplicationMailer

  def new_answer_for(question)
    @question = question
    @user = @question.user

    mail to: @user.email
  end
end
