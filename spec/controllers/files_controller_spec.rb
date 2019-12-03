require 'rails_helper'

RSpec.describe FilesController, type: :controller do

  describe 'DELETE #destroy' do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer_with_file) { create(:answer, :with_file, question: question, user: user) }
    let(:file) { answer_with_file.files.first }

    context 'Authenticated user' do
      before { login(user) }

      it 'sets file to @file' do
        delete :destroy, params: { id: file, format: :js }
        expect(assigns(:file)).to eq file
      end

      it 'sets correct record to @record' do
        delete :destroy, params: { id: file, format: :js }
        expect(assigns(:record)).to eq answer_with_file
      end

      context 'user is an author' do

        it 'deletes the file' do
          expect { delete :destroy, params: { id: file, format: :js } }.to change(answer_with_file.files, :count).by(-1)
        end

        it 'renders destroy template' do
          delete :destroy, params: { id: file, format: :js }
          expect(response).to render_template :destroy
        end
      end

      context 'user is NOT an author' do
        before { login(user2) }

        it 'does not delete the file' do
          expect { delete :destroy, params: { id: file, format: :js } }.to_not change(answer_with_file.files, :count)
        end

        it 'renders destroy template' do
          delete :destroy, params: { id: file, format: :js }
          expect(response).to render_template :destroy
        end
      end
    end

    context 'Unauthenticated user' do

      it 'does not delete the file' do
        expect { delete :destroy, params: { id: file, format: :js } }.to_not change(answer_with_file.files, :count)
      end

      it 'declares user is unauthorized' do
        delete :destroy, params: { id: file, format: :js }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
