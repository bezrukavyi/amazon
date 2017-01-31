require 'rails_helper'

RSpec.describe CartsController, type: :controller do

  subject { create :order, :with_items }
  let(:order_item) { subject.order_items.first }
  let(:coupon) { create :coupon }

  before do
    allow(controller).to receive(:current_order).and_return(subject)
  end

  describe 'GET #edit' do
    it 'assign coupon_form' do
      get :edit
      expect(assigns[:coupon_form]).to be_kind_of(CouponForm)
    end
  end

  describe 'PUT #update' do
    let(:valid_params) { { order: {
      order_items_attributes: { '0': { quantity: 2, id: order_item.id } },
      coupon: { code: coupon.code } } } }

    it 'assign coupon_form' do
      put :update, params: valid_params
      expect(assigns[:coupon_form]).to be_kind_of(CouponForm)
    end

    it 'valid event' do
      put :update, params: valid_params
      expect(response).to redirect_to(edit_cart_path)
    end

    it 'invalid event' do
      put :update, params: { order: { coupon: { code: 'wrong_coupon' } } }
      expect(response).to render_template(:edit)
    end

  end

end
