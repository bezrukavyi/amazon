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

    before do
      allow(order).to receive(:add_item).and_return(subject)
    end

    context 'success add item to order' do
      before do
        allow(subject).to receive(:save).and_return(true)
        allow(order).to receive(:save).and_return(true)
        post :create, params: { book_id: book_id, quantity: 20 }
      end

      it 'notice flash' do
        expect(flash[:notice]).to eq I18n.t('flash.success.book_add', count: 20)
      end
      it 'redirect_back' do
        expect(response).to redirect_to(book_path(book_id))
      end
    end

    context 'failed add item to order' do
      before do
        allow(subject).to receive(:save).and_return(false)
        allow(subject).to receive_message_chain(:decorate, :all_errors).and_return('errors')
        allow(order).to receive(:save).and_return(false)
        post :create, params: { book_id: book_id, quantity: 1000 }
      end

      it 'alert flash' do
        expect(flash[:alert]).to eq I18n.t('flash.failure.book_add', errors: 'errors')
      end

      it 'redirect_back' do
        expect(response).to redirect_to(book_path(book_id))
      end

    end
  end

  describe 'DELETE #destroy' do
    before do
      allow(OrderItem).to receive(:find).and_return(subject)
    end
    context 'success destroy' do
      before do
        allow(subject).to receive(:destroy).and_return(true)
        allow(order).to receive(:save).and_return(true)
        delete :destroy, params: { id: subject.id }
      end

      it 'notice flash' do
        expect(flash[:notice]).to eq I18n.t('flash.success.book_destroy', title: subject.book.title)
      end

      it 'renders the :show template' do
        expect(response).to redirect_to(edit_cart_path)
      end

    end

    context 'failed destroy' do
      before do
        allow(subject).to receive(:destroy).and_return(false)
        allow(subject).to receive_message_chain(:decorate, :all_errors).and_return('errors')
        allow(order).to receive(:save).and_return(false)
        delete :destroy, params: { id: subject.id }
      end

      it 'alert falsh' do
        expect(flash[:alert]).to eq I18n.t('flash.failure.book_destroy', errors: 'errors')
      end

      it 'redirect_to edit_cart_path' do
        expect(response).to redirect_to(edit_cart_path)
      end

    end

  end
end
