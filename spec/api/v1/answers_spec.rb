require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json",
                    "ACCEPT" => "application/json" } }
  let!(:question) { create(:question) }
  let(:access_token) { create(:access_token) }

  describe 'GET /api/v1/questions/:question_id/answers' do
    let!(:answers) { create_list(:answer, 2, question: question) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    end

    context 'authorized' do

      before { get "/api/v1/questions/#{question.id}/answers", params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Successful'

      it_behaves_like 'List of answers' do
        let(:answers_response) { json['answers'] }
      end
    end
  end

  describe 'GET /api/v1/answers/:id' do
    let!(:answer) { create(:answer, question: question) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { "/api/v1/answers/#{answer.id}" }
    end

    context 'authorized' do
      let!(:answer) { create(:answer, :with_file, question: question) }
      let!(:link) { create(:link, linkable: answer) }
      let!(:comments) { create_list(:comment, 2, commentable: answer)}

      before { get "/api/v1/answers/#{answer.id}", params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Successful'

      it_behaves_like 'Public object' do
        let(:object) { answer }
        let(:public_fields) { %w[ id body created_at updated_at ] }
        let(:response_object) { json['answer'] }
      end

      it_behaves_like 'Got associations' do
        let(:object) { answer }
        let(:list_of_associations) { %w[ user links files comments ] }
      end
    end
  end
end
