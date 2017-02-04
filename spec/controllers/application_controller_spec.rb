require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do

  describe '#current_order' do

    it 'order with session' do
      order = create :order
      session[:order_id] = order.id
      expect(controller.current_order).to eq(order)
    end

    context 'order without session' do
      it 'create order' do
        expect { controller.current_order }.to change { Order.count }.by(1)
      end
      it 'set session' do
        expect { controller.current_order }.to change { session[:order_id] }
      end
    end

  end

  describe '#fast_authenticate_user!' do
    it 'when user signed in' do
      allow(controller).to receive(:user_signed_in?).and_return(true)
      expect(controller).to receive(:authenticate_user!)
      controller.fast_authenticate_user!
    end
    it 'when user not signed in' do
      allow(controller).to receive(:user_signed_in?).and_return(false)
      path = new_user_registration_path(fast_auth: true)
      expect(controller).to receive(:redirect_to).with(path)
      controller.fast_authenticate_user!
    end
  end

end
