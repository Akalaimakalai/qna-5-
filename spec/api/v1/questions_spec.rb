require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json",
                    "ACCEPT" => "application/json" } }
  let(:access_token) { create(:access_token) }

  describe 'GET /api/v1/questions' do

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/questions' }
    end

    context 'authorized' do
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question)}

      before { get '/api/v1/questions', params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Successful'

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it_behaves_like 'Public object' do
        let(:object) { question }
        let(:public_fields) { %w[ id title body created_at updated_at ] }
        let(:response_object) { question_response }
      end

      it 'contains user object' do
        expect(question_response['user']['id']).to eq question.user.id
      end

      it 'contents short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      describe 'answers' do
        it_behaves_like 'List of answers' do
          let(:answers_response) { question_response['answers'] }
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let(:question) { create(:question) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { "/api/v1/questions/#{question.id}" }
    end

    context 'authorized' do
      let!(:question) { create(:question, :with_file) }
      let!(:answers) { create_list(:answer, 2, question: question)}
      let!(:link) { create(:link, linkable: question) }
      let!(:comments) { create_list(:comment, 2, commentable: question)}

      before { get "/api/v1/questions/#{question.id}", params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Successful'

      it_behaves_like 'Public object' do
        let(:object) { question }
        let(:public_fields) { %w[ id title body created_at updated_at ] }
        let(:response_object) { json['question'] }
      end

      it_behaves_like 'Got associations' do
        let(:object) { question }
        let(:list_of_associations) { %w[ user links files comments answers ] }
      end
    end
  end

  describe 'POST /api/v1/questions' do
    let(:headers) { { "ACCEPT" => "application/json" } }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
      let(:api_path) { '/api/v1/questions' }
    end

    context 'authorized' do
      let(:params) { { access_token: access_token.token,
                       question: { title: "NewTestQuestionTitile", body: "LookAtThatBody" } } }

      before { post "/api/v1/questions", params: params, headers: headers }

      it_behaves_like 'Successful'

      it_behaves_like 'Could be created' do
        let(:klass) { Question }
        let(:api_path) { "/api/v1/questions" }
        let(:hash_of_fields) { { 'title' => "NewTestQuestionTitile", 'body' => "LookAtThatBody"} }
      end
    end
  end

  describe 'PATCH /api/v1/questions/:id' do
    let(:headers) { { "ACCEPT" => "application/json" } }
    let(:question) { create(:question) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
      let(:api_path) { "/api/v1/questions/#{question.id}" }
    end

    context 'authorized' do
      let(:params) { { access_token: access_token.token,
                       question: { title: "NewTestQuestionTitile", body: "LookAtThatBody" } } }

      before { patch "/api/v1/questions/#{question.id}", params: params, headers: headers }

      it_behaves_like 'Successful'

      it_behaves_like 'Could be updated' do
        let(:object) { question }
        let(:hash_of_fields) { { 'title' => "NewTestQuestionTitile", 'body' => "LookAtThatBody"} }
      end
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let(:headers) { { "ACCEPT" => "application/json" } }
    let!(:question) { create(:question) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
      let(:api_path) { "/api/v1/questions/#{question.id}" }
    end

    context 'authorized' do

      it_behaves_like 'Could be deleted' do
        let(:klass) { Question }
        let(:api_path) { "/api/v1/questions/#{question.id}" }
      end
    end
  end
end
