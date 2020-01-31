class DailyDigestService

  def self.send_digest
    return if Question.where(created_at: 1.day.ago.all_day).empty?

    User.find_each do |user|
      DailyDigestMailer.digest(user).deliver_later
    end
  end
end
