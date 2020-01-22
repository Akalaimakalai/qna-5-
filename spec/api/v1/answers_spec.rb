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

    it_behaves_like 'Successful'

    it_behaves_like 'List of answers' do
      let(:answers_response) { json['answers'] }
    end
  end
end
