class SubscriptionsController < ApplicationController

  authorize_resource

  def create
    @subscription = current_user.subscriptions.new
    @question = Question.find(params[:resource][:id])

    return flash[:alert] = "You are already following question" if current_user.subs.include?(@question)

    @subscription.question_id = @question.id
    @subscription.save!
  end
end
