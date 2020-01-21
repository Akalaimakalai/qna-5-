class MedalsController < ApplicationController
  before_action :authenticate_user!

  authorize_resource

  def index
    @medals = current_user.medals
  end
end
