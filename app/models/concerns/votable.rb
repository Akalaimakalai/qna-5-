require 'active_support/concern'

module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable
  end

  def sum_votes
    votes.sum(:value)
  end

  def delete_voter(user)
    votes.where(user: user).delete_all
  end
end
