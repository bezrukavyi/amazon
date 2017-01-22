require 'rails_helper'

RSpec.describe OrderItemsController, type: :controller do

  let(:user) { create :user }
  subject { create :order, user: user }
  let(:order_item) { create :order_item, quantity: 1, order: subject }

  before do
    sign_in user
  end

  describe 'POST #create' do
    let(:book_id) { order_item.book.id }

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
end
