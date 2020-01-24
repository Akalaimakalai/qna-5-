require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json",
                    "ACCEPT" => "application/json" } }
  let(:access_token) { create(:access_token) }
  let(:user) { User.find(access_token.resource_owner_id)}
  let!(:question) { create(:question, user: user) }

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
      let!(:comments) { create_list(:comment, 2, commentable: answer)}
      let!(:link) { create(:link, linkable: answer) }

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

  describe 'POST /api/v1/questions/:question_id/answers' do
    let(:headers) { { "ACCEPT" => "application/json" } }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
      let(:api_path) { '/api/v1/questions/:question_id/answers' }
    end

    context 'authorized' do
      let(:params) { { access_token: access_token.token, answer: { body: "AnswerBody" } } }

      before { post "/api/v1/questions/#{question.id}/answers", params: params, headers: headers }

      it_behaves_like 'Successful'

      it_behaves_like 'Could be created' do
        let(:klass) { Answer }
        let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
        let(:hash_of_fields) { { 'body' => "AnswerBody" } }
      end
    end
  end

  describe 'PATCH /api/v1/answers/:id' do
    let(:headers) { { "ACCEPT" => "application/json" } }
    let!(:answer) { create(:answer, question: question, user: user) }
    let(:params) { { access_token: access_token.token, answer: { body: "AnswerBody" } } }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
      let(:api_path) { "/api/v1/answers/#{answer.id}" }
    end

    context 'authorized' do
      let!(:old_body) { answer.body }

      before { patch "/api/v1/answers/#{answer.id}", params: params, headers: headers }

      it_behaves_like 'Successful'

      it_behaves_like 'Could be updated' do
        let(:object) { answer }
        let(:hash_of_fields) { { 'body' => "AnswerBody" } }
      end
    end
  end

  describe 'DELETE /api/v1/answers/:id' do
    let(:headers) { { "ACCEPT" => "application/json" } }
    let!(:answer) { create(:answer, question: question, user: user) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
      let(:api_path) { "/api/v1/answers/#{answer.id}" }
    end

    context 'authorized' do
      it_behaves_like 'Could be deleted' do
        let(:klass) { Answer }
        let(:api_path) { "/api/v1/answers/#{answer.id}" }
      end
    end
  end
end
