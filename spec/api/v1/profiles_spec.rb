require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json",
                    "ACCEPT" => "application/json" } }

  describe 'GET /api/v1/profiles/me' do

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/profiles/me' }
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Successful'

      it_behaves_like 'Public object' do
        let(:object) { me }
        let(:public_fields) { %w[ id email admin created_at updated_at ] }
        let(:response_object) { json['user'] }
      end

      it 'does not return private fields' do
        %w[ password encrypted_password ].each do |attr|
          expect(json).to_not have_key(attr)
        end
      end
    end
  end

  describe 'GET /api/v1/profiles/all' do

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/profiles' }
    end

    context 'authorized' do
      let!(:users) { create_list(:user, 3)}
      let(:user) { users.first }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      before { get '/api/v1/profiles', params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Successful'

      it 'returns list of users' do
        expect(json['users'].size).to eq 2
      end

      it 'does not include current user' do
        expect(json['users']).to_not be_include(user)
      end

      context 'every user' do
        it_behaves_like 'Public object' do
          let(:object) { users.last }
          let(:public_fields) { %w[ id email admin created_at updated_at ] }
          let(:response_object) { json['users'].last }
        end

        it 'does not return private fields' do
          %w[ password encrypted_password ].each do |attr|
            expect(json['users'].last).to_not have_key(attr)
          end
        end
      end
    end
  end
end
