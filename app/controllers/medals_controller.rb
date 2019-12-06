class MedalsController < ApplicationController
  before_action :authenticate_user!

  def index
    @medals = current_user.medals
  end
end
