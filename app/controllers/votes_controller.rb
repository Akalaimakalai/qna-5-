class VotesController < ApplicationController
  before_action :authenticate_user!

  def create
    @user = current_user
    @vote = @user.votes.new(vote_params)
    @record = @vote.votable

    return flash.now[:alert] = "You can't vote for youself" if @user.is_author?(@record)

    @record.delete_voter(@user)
    @vote.save
    @record.reload
  end

  private

  def vote_params
    params[:vote].permit(:votable_type, :votable_id, :value)
  end
end
