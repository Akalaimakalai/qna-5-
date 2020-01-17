class ApplicationController < ActionController::Base
  before_action :set_host_for_local_storage

  private

  def set_host_for_local_storage
    env_now ||= Rails.application.config.active_storage.service
    ActiveStorage::Current.host ||= request.base_url if env_now == :test
  end
end
