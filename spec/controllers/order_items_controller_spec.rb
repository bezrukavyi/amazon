require 'rails_helper'

RSpec.describe OrderItemsController, type: :controller do

  let(:user) { create :user }
  let(:order) { create :order, :with_items }
  subject { order.order_items.first }

  before do
    sign_in user
    allow(controller).to receive(:current_order).and_return(order)
  end

  describe 'POST #create' do
    let(:book_id) { subject.book.id }

    context 'success add item to order' do
      let(:create_params) { { book_id: book_id, quantity: 20 } }

      it 'update subject quantity' do
        expect { post :create, params: create_params }
          .to change { subject.reload.quantity }.by(20)
      end
      it 'update order total price' do
        expect { post :create, params: create_params }
          .to change { order.reload.total_price }
      end
      it 'redirect_back' do
        post :create, params: create_params
        expect(response).to redirect_to(book_path(book_id))
      end
    end

    context 'failed add item to order' do
      let(:create_params) { { book_id: book_id, quantity: 1000 } }
      it 'redirect_back' do
        post :create, params: create_params
        expect(response).to redirect_to(book_path(book_id))
      end
      it 'update order total price' do
        expect { post :create, params: create_params }
          .not_to change(order, :total_price)
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
