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

    context 'order with current_user' do
      let(:order) { create :order, :with_items }
      let(:user) { create :user }
      before do
        allow(Order).to receive(:find_by).and_return(order)
        allow(controller).to receive(:current_user).and_return(user)
      end
      it 'merge order' do
        user_order = create :order
        expect(user).to receive(:order_in_processing).and_return(user_order)
        expect(user_order).to receive(:merge_order!).with(order).and_return(order)
        controller.current_order
      end
    end

  end

end
