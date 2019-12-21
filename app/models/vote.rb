class Vote < ApplicationRecord
  before_create :prepare_revote
  after_save :count_votes

  belongs_to :votable, polymorphic: true
  belongs_to :user

  validates :value, presence: true
  validates :value, numericality: { only_integer: true }

  private

  def prepare_revote
    votable.delete_voter(user)
  end

  def count_votes
    votable.sum_votes
    votable.save
  end
end
