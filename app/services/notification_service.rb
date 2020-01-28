class NotificationService

  def new_answer_for(question)
    question.followers.each do |user|
      NotificationMailer.new_answer(question, user).deliver_later
    end
  end
end
