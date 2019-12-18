class ScoresController < ApplicationController
  before_action :authenticate_user!

  def update
    @score = Score.find(params[:id])
    user = current_user

    return flash.now[:alert] = "You can't vote for yourself" if @score.author == user

    @score.delete_voter(user)
    @score.votes.create(vote_params)
    @score.count_sum

    respond_to do |format|
      format.json { render json: @score } if @score.save
    end
  end

  private

  def vote_params
    params_hash = params.require(:vote).permit(:value)
    params_hash[:user_id] = current_user.id
    params_hash
  end
end
