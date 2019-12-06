require 'rails_helper'

RSpec.describe MedalsController, type: :controller do

  describe 'GET #index' do
    let(:user) { create(:user) }
    let(:medals) { create_list(:medal, 3, user: user) }

    before do
      login(user)
      get :index
    end

    it "populates an array of all user's medals" do
      expect(assigns(:medals)).to match_array(medals)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

end
