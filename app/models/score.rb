class Score < ApplicationRecord
  belongs_to :author, class_name: "User"
  belongs_to :scorable, polymorphic: true

  validates :sum, presence: true

  def vote_for
    sum += 1
  end

  def vote_against
    sum -= 1
  end
end
