class ComentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @coment = current_user.coments.new(coment_params)
    @coment.save
  end

  private

  def coment_params
    params[:coment].permit(:comentable_type, :comentable_id, :body)
  end
end
