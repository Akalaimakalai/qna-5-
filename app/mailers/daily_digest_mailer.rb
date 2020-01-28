class DailyDigestMailer < ApplicationMailer

  def digest(user)
    @user = user
    @questions = Questions.yesterday

    mail to: @user.email
  end
end
