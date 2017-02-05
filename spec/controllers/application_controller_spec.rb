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

end
