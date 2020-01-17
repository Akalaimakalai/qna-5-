require 'rails_helper'

RSpec.describe OauthCallbacksController, type: :controller do

  before { @request.env["devise.mapping"] = Devise.mappings[:user] }

  describe 'GET #github' do
    include_examples "authenticate_with_provider", :github
  end

  describe 'GET #vkontakte' do
    include_examples "authenticate_with_provider", :vkontakte
  end
end
