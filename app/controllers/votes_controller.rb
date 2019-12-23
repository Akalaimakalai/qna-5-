class VotesController < ApplicationController
  before_action :authenticate_user!

  def create

    @vote = current_user.votes.new(vote_params)
    @record = @vote.votable

    if !current_user.is_author?(@record) && @vote.save
      @record.reload
      respond_to do |format|
        format.json { render json: { klass: @record.class.name.underscore,
                                     id: @record.id,
                                     sum: @record.sum_votes }
                    }
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
