require 'active_support/concern'

module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable
    validates :score, presence: true
  end

  def sum_votes
    self.score = votes.sum(:value)
  end

  def delete_voter(user)
    votes.where(user: user).delete_all
  end
end
