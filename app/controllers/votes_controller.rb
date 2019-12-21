class VotesController < ApplicationController
  before_action :authenticate_user!

  def create

    @vote = current_user.votes.new(vote_params)

    if !current_user.is_author?(@vote.votable) && @vote.save
      respond_to do |format|
        format.json { render json: @vote.votable }
      end
    else
      flash.now[:alert] = "You can't vote for youself"
    end
  end

  private

  def vote_params
    params[:vote].permit(:votable_type, :votable_id, :value)
  end
end
