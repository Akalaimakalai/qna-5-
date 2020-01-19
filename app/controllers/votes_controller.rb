class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_vote

  authorize_resource

  def create
    @record = @vote.votable

    @vote.save!
    @record.reload
    respond_to do |format|
      format.json { render json: { klass: @record.class.name.underscore,
                                    id: @record.id,
                                    sum: @record.sum_votes }
                  }
    end
  end

  private

  def set_vote
    @vote = current_user.votes.new(vote_params)
  end

  def vote_params
    params[:vote].permit(:votable_type, :votable_id, :value)
  end
end
