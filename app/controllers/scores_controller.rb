class ScoresController < ApplicationController
  before_action :authenticate_user!

  VOTE_LIST = %w[ vote_for vote_against ].freeze

  def vote
    if VOTE_LIST.include?(params[:vote])
      @score = Score.find(params[:id])
      user_id = current_user.id

      return flash.now[:alert] = "You can't vote for yourself" if @score.author == current_user
      return flash.now[:alert] = "You have already voted" if @score.already_voted?(user_id)

      @score.send(params[:vote], user_id)
      @score.save
    else
      flash.now[:alert] = "Wrong value of vote param"
    end
  end
end
