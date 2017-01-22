require 'rails_helper'

RSpec.describe CartsController, type: :controller do

  subject { create :order }
  let(:order_item) { create :order_item, quantity: 1, order: subject }
  let(:coupon) { create :coupon }

  describe 'PUT #update' do

    before do
      allow(controller).to receive(:current_order).and_return(subject)
    end

    context 'Valid' do

      let(:valid_params) { { id: subject.id,
        order: { order_items_attributes: { 0 => { quantity: 2, id: order_item.id } },
        coupon: { code: coupon.code } } } }

      it 'update order items' do
        expect { put :update, params: valid_params }
        .to change { order_item.reload.quantity }.from(1).to(2)
      end

      it 'update coupon' do
        expect { put :update, params: valid_params }
        .to change { subject.coupon }.from(nil).to(coupon)
      end

      it 'redirect to cart_path' do
        put :update, params: valid_params
        expect(response).to redirect_to(cart_path)
      end

    end

    context 'Invalid' do

      let(:invalid_params) { { id: subject.id,
        order: { order_items_attributes: { 0 => { quantity: -100, id: order_item.id } },
        coupon: { code: coupon.code } } } }

      it 'update data' do
        expect { put :update, params: invalid_params }
        .not_to change { order_item.reload.quantity }
      end

      it 'render :edit' do
        put :update, params: invalid_params
        expect(response).to render_template(:edit)
      end

    end

  end

end
