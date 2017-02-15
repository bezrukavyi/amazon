describe UpdateOrder do
  let(:order) { create :order, :with_items }
  let(:order_item) { order.order_items.first }

  context 'update order items' do
    context 'success update' do
      let(:params) do
        { order: { order_items_attributes: { id: order_item.id,
                                             quantity: 20 } } }
      end
      subject { UpdateOrder.new(order, params) }
      before do
        allow(subject).to receive(:order_params).and_return(params[:order])
      end

      it 'set valid broadcast' do
        expect { subject.call }.to broadcast(:valid)
      end

      it 'set to_checkout broadcast' do
        params[:to_checkout] = true
        expect { subject.call }.to broadcast(:to_checkout)
      end
      it 'change order items' do
        expect { subject.call }.to change { order_item.reload.quantity }.from(1)
          .to(20)
      end
    end

    context 'failure update' do
      let(:params) do
        { order: { order_items_attributes: { id: order_item.id,
                                             quantity: -100 } } }
      end
      subject { UpdateOrder.new(order, params) }
      before do
        allow(subject).to receive(:order_params)
          .and_return(params[:order])
      end
      it 'set valid broadcast' do
        expect { subject.call }.to broadcast(:invalid)
      end
      it 'change order items' do
        expect { subject.call }.not_to change { order_item.reload }
      end
    end
  end

  context 'update coupon' do
    let(:coupon) { create :coupon }
    let(:params) { { order: { coupon: { code: coupon.code } } } }
    subject { UpdateOrder.new(order, params) }
    before { allow(subject).to receive(:order_params).and_return({}) }

    it 'set new coupon' do
      expect { subject.call }.to change { order.reload.coupon }
        .from(nil).to(coupon)
    end
    it 'coupon not found' do
      allow(Coupon).to receive(:find_by_code).and_return(nil)
      expect { subject.call }.to broadcast(:invalid)
    end
    it 'when coupon exist and belongs subject' do
      order.coupon = coupon
      allow(subject).to receive(:coupon_form)
        .and_return(CouponForm.from_model(coupon))
      expect { subject.call }.to broadcast(:valid)
    end
  end
end
