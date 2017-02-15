describe CartsController, type: :controller do
  subject { create :order, :with_items }
  let(:order_item) { subject.order_items.first }
  let(:coupon) { create :coupon }

  before do
    allow(controller).to receive(:current_order).and_return(subject)
  end

  describe 'GET #edit' do
    it 'assign coupon_form' do
      allow(CouponForm).to receive(:from_model).with(subject.coupon)
      get :edit
    end
  end

  describe 'PUT #update' do
    let(:params) { { order: { coupon: { code: coupon.code } } } }

    it 'UpdateOrder call' do
      allow(controller).to receive(:params).and_return(params)
      expect(UpdateOrder).to receive(:call).with(subject, params)
      put :update, params: params
    end

    context 'success update' do
      before do
        stub_const('UpdateOrder', Support::Command::Valid)
        put :update, params: params
      end
      it 'flash notice' do
        expect(flash[:notice]).to eq(I18n.t('flash.success.cart_update'))
      end
      it 'redirect to edit user' do
        expect(response).to redirect_to(edit_cart_path)
      end
    end

    context 'success update and to checkout' do
      before do
        stub_const('UpdateOrder', Support::Command::ToCheckout)
        put :update, params: params
      end
      it 'flash notice' do
        expect(flash[:notice]).to eq(I18n.t('flash.success.cart_update'))
      end
      it 'redirect to edit user' do
        expect(response).to redirect_to(checkout_path(:address))
      end
    end

    context 'failure update' do
      let(:coupon_form) { double('coupon_form') }
      before do
        stub_const('UpdateOrder', Support::Command::Invalid)
        Support::Command::Invalid.block_value = coupon_form
        put :update, params: params
      end
      it 'flash notice' do
        expect(flash[:alert]).to eq(I18n.t('flash.failure.cart_update'))
      end
      it 'redirect to edit user' do
        expect(response).to render_template(:edit)
      end
      it 'instance review_form' do
        expect(assigns(:coupon_form)).to eq(coupon_form)
      end
    end
  end
end
