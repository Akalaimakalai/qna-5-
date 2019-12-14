class Score < ApplicationRecord
  belongs_to :author, class_name: "User"
  belongs_to :scorable, polymorphic: true

  validates :sum, presence: true

  def vote_for
    self.sum += 1
  end

  def vote_against
    self.sum -= 1
  end
end
