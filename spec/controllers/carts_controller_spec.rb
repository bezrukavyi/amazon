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
    let(:valid_params) do
      { order: {
        order_items_attributes: { '0' => { quantity: 2, id: order_item.id } },
        coupon: { code: coupon.code }
      } }
    end
    let(:coupon_form) { CouponForm.new(valid_params[:order][:coupon]) }
    let(:parameters) { ActionController::Parameters.new(valid_params) }

    context 'success' do
      before do
        allow(CouponForm).to receive(:from_params)
          .with(parameters[:order][:coupon]).and_return(coupon_form)
      end

      it 'UpdateOrder call' do
        expect(UpdateOrder).to receive(:call)
        put :update, params: valid_params
      end

      it 'assign coupon_form' do
        put :update, params: valid_params
        expect(assigns[:coupon_form]).not_to be_nil
      end

      it 'redirect_to cart' do
        put :update, params: valid_params
        expect(response).to redirect_to(edit_cart_path)
      end

      it 'flash notice' do
        put :update, params: valid_params
        expect(flash[:notice]).to eq I18n.t('flash.success.cart_update')
      end
    end

    context 'failure' do
      before do
        put :update, params: { order: { coupon: { code: 'wrong_coupon' } } }
      end
      it 'render edit' do
        expect(response).to render_template(:edit)
      end
      it 'flash alert' do
        expect(flash[:alert]).to eq I18n.t('flash.failure.cart_update')
      end
    end
  end
end
