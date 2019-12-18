class Score < ApplicationRecord
  belongs_to :author, class_name: "User"
  belongs_to :scorable, polymorphic: true
  has_many :votes, dependent: :destroy

  validates :sum, presence: true

  def delete_voter(user)
    vote_arr = votes.select { |vote| vote.user == user }
    votes.delete(vote_arr.first) unless vote_arr.empty?
  end

  def count_sum
    vote_sum = 0
    votes.each { |vote| vote_sum += vote.value }
    self.sum = vote_sum
  end
end
