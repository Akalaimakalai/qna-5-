class Score < ApplicationRecord
  belongs_to :author, class_name: "User"
  belongs_to :scorable, polymorphic: true

  validates :sum, presence: true

  def already_voted?(user_id)
    voters.keys.include?(user_id.to_s)
  end

  private

  def vote_for(user_id)
    self.sum += 1
    voters[user_id] = 1
  end

  def vote_against(user_id)
    self.sum -= 1
    voters[user_id] = -1
  end
end
