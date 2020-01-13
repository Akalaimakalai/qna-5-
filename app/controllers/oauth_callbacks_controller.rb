class OauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :set_user

  def github
    standart_method_logic('GitHub')
  end

  def vkontakte
    standart_method_logic('Vkontakte')
  end

  private

  def set_user
    @user = User.find_for_oauth(request.env['omniauth.auth'])
  end

  def standart_method_logic(provider_name)
    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider_name) if is_navigational_format?
    else
      redirect_to root_path, alert: "Something went wrong"
    end
  end
end
