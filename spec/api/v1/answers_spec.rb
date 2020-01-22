require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json",
                    "ACCEPT" => "application/json" } }
  let!(:question) { create(:question) }
  let!(:answers) { create_list(:answer, 2, question: question) }

  describe 'GET /api/v1/questions/:question_id/answers' do

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    end
  end

  context 'authorized' do
    let(:access_token) { create(:access_token) }

    before { get "/api/v1/questions/#{question.id}/answers", params: { access_token: access_token.token }, headers: headers }

    it 'returns 200 status' do
      expect(response).to be_successful
    end

    it 'returns list of answers' do
      expect(json['answers'].size).to eq 2
    end

    it 'returns all public fields' do
      %w[ id body user_id created_at updated_at ].each do |attr|
        expect(json['answers'].first[attr]).to eq answers.first.send(attr).as_json
      end
    end
  end
end
