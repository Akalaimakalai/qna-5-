class FindForOauthService

  def self.call(auth)
    authorization = Authorization.find_by(provider: auth.provider, uid: auth.uid.to_s)

    return authorization.user if authorization

    email = auth.info[:email]
    user = User.find_by(email: email)

    unless user
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: email, password: password, password_confirmation: password)
    end

    user.authorizations.create!(provider: auth.provider, uid: auth.uid)

    user
  end
end
