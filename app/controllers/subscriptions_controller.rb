class SubscriptionsController < ApplicationController

  authorize_resource

  def create
    @question = Question.find(params[:question_id])
    @subscription = Subscription.create(user_id: current_user.id, question_id: @question.id)
  end

  def destroy
    @subscription = Subscription.find(params[:id])
    @question = @subscription.question
    @subscription.destroy!
  end
end
