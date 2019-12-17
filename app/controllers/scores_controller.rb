class ScoresController < ApplicationController
  before_action :authenticate_user!
  before_action :set_score_and_user_id, only: %i[ revote ]

  VOTE_LIST = %w[ vote_for vote_against ].freeze

  def vote
    if VOTE_LIST.include?(params[:vote])
      set_score_and_user_id

      return flash.now[:alert] = "You can't vote for yourself" if @score.author == current_user
      return flash.now[:alert] = "You have already voted" if @score.already_voted?(@user_id)

      @score.send(params[:vote], @user_id)

      respond_to do |format|
        if @score.save
          format.json { render json: @score }
        end
      end
    else
      flash.now[:alert] = "Wrong value of vote param"
    end
  end

  def revote

    return flash.now[:alert] = "You didn't vote yet" unless @score.already_voted?(@user_id)

    @score.revote(@user_id)
    respond_to do |format|
      if @score.save
        format.json { render json: @score }
      end
    end
  end

  private

  def set_score_and_user_id
    @score = Score.find(params[:id])
    @user_id = current_user.id
  end
end
