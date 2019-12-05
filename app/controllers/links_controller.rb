class LinksController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @link = Link.find(params[:id])
    @record = @link.linkable

    @link.destroy if current_user.is_author?(@record)
  end
end
