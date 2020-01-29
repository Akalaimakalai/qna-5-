class SubscriptionsController < ApplicationController
  before_action :find_subscription, only: %i[ destroy ]

  authorize_resource

  def create
    @question = Question.find(params[:question_id])

    return flash[:alert] = "You are already following question" if current_user.subs.include?(@question)

    @subscription = current_user.subscriptions.new

    @subscription.question_id = @question.id
    @subscription.save!
  end

  def destroy
    @question = @subscription.question
    @subscription.destroy!
  end

  private

  def find_subscription
    @subscription = Subscription.find(params[:id])
  end
end
