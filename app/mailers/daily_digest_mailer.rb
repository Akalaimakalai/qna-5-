class DailyDigestMailer < ApplicationMailer

  def digest(user)
    @user = user
    @questions = Question.yesterday

    mail to: @user.email
  end
end
