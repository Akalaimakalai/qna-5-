class ScoresController < ApplicationController
  before_action :authenticate_user!

  VOTE_LIST = %w[ vote_for vote_against ].freeze

  def vote
    if VOTE_LIST.include?(params[:vote])
      @score = Score.find(params[:id])
      @score.send(params[:vote])
      @score.save
    else
      redirect_to root_path, alert: "Wrong value of vote param"
    end
  end
end
