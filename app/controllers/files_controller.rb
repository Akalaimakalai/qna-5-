class FilesController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @file = ActiveStorage::Attachment.find(params[:id])
    @record = Object.const_get(@file.record_type).find(@file.record_id)

    @file.purge if current_user.is_author?(@record)
  end
end
