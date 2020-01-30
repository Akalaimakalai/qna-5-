class NotificationService

  def self.new_answer_for(question, answer)
    question.followers.find_each do |user|
      NotificationMailer.new_answer(question, answer, user).deliver_later
    end
  end
end
