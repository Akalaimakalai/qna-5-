require 'rails_helper'

RSpec.describe LinksController, type: :controller do

  describe 'DELETE #destroy' do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question, user: user) }
    let!(:link) { create(:link, linkable: answer) }

    context 'Authenticated user' do
      before { login(user) }

      it 'sets link to @link' do
        delete :destroy, params: { id: link, format: :js }
        expect(assigns(:link)).to eq link
      end

      it 'sets correct record to @record' do
        delete :destroy, params: { id: link, format: :js }
        expect(assigns(:record)).to eq answer
      end

      context 'user is an author' do

        it 'deletes the link' do
          expect { delete :destroy, params: { id: link, format: :js } }.to change(answer.links, :count).by(-1)
        end

        it 'renders destroy template' do
          delete :destroy, params: { id: link, format: :js }
          expect(response).to render_template :destroy
        end
      end

      context 'user is NOT an author' do
        before { login(user2) }

        it 'does not delete the link' do
          expect { delete :destroy, params: { id: link, format: :js } }.to_not change(answer.links, :count)
        end

        it 'renders destroy template' do
          delete :destroy, params: { id: link, format: :js }
          expect(response).to render_template :destroy
        end
      end
    end

    context 'Unauthenticated user' do

      it 'does not delete the link' do
        expect { delete :destroy, params: { id: link, format: :js } }.to_not change(answer.files, :count)
      end

      it 'declares user is unauthorized' do
        delete :destroy, params: { id: link, format: :js }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
