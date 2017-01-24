require 'rails_helper'

RSpec.describe OrderItemsController, type: :controller do

  let(:user) { create :user }
  subject { create :order_item, quantity: 1 }
  let(:order) { subject.order }

  before do
    sign_in user
  end

  describe 'POST #create' do
    let(:book_id) { subject.book.id }

    context 'success add item to order' do
      let(:create_params) { { book_id: book_id, quantity: 20 } }
      it 'redirect_back' do
        post :create, params: create_params
        expect(response).to redirect_to(book_path(book_id))
      end
    end

    context 'faile add item to order' do
      let(:create_params) { { book_id: book_id, quantity: 1000 } }
      it 'redirect_back' do
        post :create, params: create_params
        expect(response).to redirect_to(book_path(book_id))
      end
    end
  end

  describe 'GET #destroy' do
    before do
      delete :destroy, params: { id: subject.id }
    end
    it 'assigns the requested order' do
      expect(assigns(:order_item)).to eq(subject)
    end
    it 'assigns the requested order' do
      expect(OrderItem.find_by(id: subject.id)).to be_nil
    end
    it 'renders the :show template' do
      expect(response).to redirect_to(cart_path)
    end
  end
end
