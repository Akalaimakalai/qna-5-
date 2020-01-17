class FilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_file

  authorize_resource

  def destroy
    @record = @file.record

    @file.purge if current_user.is_author?(@record)
  end

  private

  def set_file
    @file = ActiveStorage::Attachment.find(params[:id])
  end
end
