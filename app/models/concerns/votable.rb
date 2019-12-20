require 'active_support/concern'

module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable
  end

  def sum_votes
    sum = 0
    self.votes.each { |vote| sum += vote.value }
    sum
  end

  def delete_voter(user)
    vote_arr = votes.select { |vote| vote.user == user }
    votes.delete(vote_arr.first) unless vote_arr.empty?
  end
end
