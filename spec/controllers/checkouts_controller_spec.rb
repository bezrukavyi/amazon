describe CheckoutsController, type: :controller do
  let(:user) { create :user }

  before do
    sign_in user
  end

  context 'Concern Addressable' do
    it_behaves_like 'addressable_attrubutes'
  end

  describe 'GET #show' do
    context 'accessed' do
      let(:order) { create :order, :checkout_package, user: user }

      before do
        allow(controller).to receive(:current_order).and_return(order)
      end

      it 'address step' do
        get :show, params: { id: :address }
        expect(response).to render_template :address
      end

      it 'delivery step' do
        get :show, params: { id: :delivery }
        expect(response).to render_template :delivery
      end

      it 'payment step' do
        get :show, params: { id: :payment }
        expect(response).to render_template :payment
      end

      it 'confirm step' do
        get :show, params: { id: :confirm }
        expect(response).to render_template :confirm
      end

      it 'complete step' do
        order.confirm
        get :show, params: { id: :complete }
        expect(response).to render_template :complete
      end
    end

    context 'not allow' do
      let(:order) { create :order, :with_items, user: user }

      before do
        allow(controller).to receive(:current_order).and_return(order)
      end

      it 'flash alert' do
        get :show, params: { id: :delivery }
        expect(flash[:alert]).to eq I18n.t('flash.failure.step')
      end

      it 'delivery step' do
        get :show, params: { id: :delivery }
        expect(response).to redirect_to checkout_path(:address)
      end

      it 'payment step' do
        get :show, params: { id: :payment }
        expect(response).to redirect_to checkout_path(:delivery)
      end

      it 'confirm step' do
        get :show, params: { id: :confirm }
        expect(response).to redirect_to checkout_path(:payment)
      end

      it 'complete step' do
        get :show, params: { id: :complete }
        expect(response).to redirect_to checkout_path(:confirm)
      end
    end
  end

  describe 'PUT #update' do
    let(:order) { create :order, :checkout_package, user: user }
    let(:order_item) { create :order_item, quantity: 1, order: order }

    before do
      allow(controller).to receive(:current_order).and_return(order)
      Support::Command::Invalid.block_value = {
        step_results: double('step_results')
      }
    end

    context 'address step' do
      let(:params) { { id: :address, order: {} } }

      it 'Checkout::StepAddress call' do
        expect(Checkout::StepAddress).to receive(:call)
        put :update, params: params
      end

      it 'success update' do
        stub_const('Checkout::StepAddress', Support::Command::Valid)
        put :update, params: params
        expect(response).to redirect_to checkout_path(:delivery)
      end

      it 'failure update' do
        stub_const('Checkout::StepAddress', Support::Command::Invalid)
        put :update, params: params
        expect(response).to render_template :address
      end
    end

    context 'delivery step' do
      let(:params) { { id: :delivery, order: {} } }

      it 'Checkout::StepDelivery call' do
        expect(Checkout::StepDelivery).to receive(:call)
        put :update, params: params
      end

      it 'success update' do
        stub_const('Checkout::StepDelivery', Support::Command::Valid)
        put :update, params: params
        expect(response).to redirect_to checkout_path(:payment)
      end

      it 'failure update' do
        stub_const('Checkout::StepDelivery', Support::Command::Invalid)
        put :update, params: params
        expect(response).to render_template :delivery
      end
    end

    context 'payment step' do
      let(:params) { { id: :payment, order: {} } }

      it 'Checkout::StepPayment call' do
        expect(Checkout::StepPayment).to receive(:call)
        put :update, params: params
      end

      it 'success update' do
        stub_const('Checkout::StepPayment', Support::Command::Valid)
        put :update, params: params
        expect(response).to redirect_to checkout_path(:confirm)
      end

      it 'failure update' do
        stub_const('Checkout::StepPayment', Support::Command::Invalid)
        put :update, params: params
        expect(response).to render_template :payment
      end
    end

    context 'confirm step' do
      let(:params) { { id: :confirm, confirm: true } }

      it 'Checkout::StepConfirm call' do
        expect(Checkout::StepConfirm).to receive(:call)
        put :update, params: params
      end

      it 'success update' do
        stub_const('Checkout::StepConfirm', Support::Command::Valid)
        put :update, params: params
        expect(response).to redirect_to checkout_path(:complete)
      end

      it 'failure update' do
        stub_const('Checkout::StepConfirm', Support::Command::Invalid)
        put :update, params: params
        expect(response).to render_template :confirm
      end
    end
  end
end
