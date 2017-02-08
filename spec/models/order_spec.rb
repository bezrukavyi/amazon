require 'rails_helper'

RSpec.describe Order, type: :model do

  subject { build :order }

  context 'associations' do
    [:user, :credit_card, :delivery].each do |model_name|
      it { should belong_to(model_name) }
    end
    it { should have_many(:order_items) }
    it { should have_one(:coupon) }
    it { should accept_nested_attributes_for(:order_items) }
  end

  context 'Concern Addressing' do
    it_behaves_like 'addressable_relation'
  end

  context 'aasm state' do
    it 'processing -> in_progress' do
      expect(subject).to transition_from(:processing).to(:in_progress).on_event(:confirm)
    end
    it 'in_progress -> in_transit' do
      expect(subject).to transition_from(:in_progress).to(:in_transit).on_event(:sent)
    end
    it 'in_transit -> delivered' do
      expect(subject).to transition_from(:in_transit).to(:delivered).on_event(:delivered)
    end
    it 'in_progress -> cancel' do
      expect(subject).to transition_from(:in_progress).to(:canceled).on_event(:cancel)
    end
  end

  describe '#add_item' do
    it 'when order item exist' do
      order_item = create :order_item, order: subject
      expect { subject.add_item(order_item.book.id, 20).save }
        .to change { order_item.reload.quantity }.by(20)
    end
    it 'when order item not exist' do
      book = create :book
      expect { subject.add_item(book.id).save }
        .to change { OrderItem.count }.by(1)
    end
    it 'when order item quantity is zero' do
      book = create :book
      expect(subject.add_item(book.id, 0)).to be_nil
    end
  end

  describe '#merge_order!' do
    it 'when current order' do
      order = create :order, :with_items
      expect { order.merge_order!(order) }.not_to change(order, :order_items)
    end
    context 'when another order' do
      before do
        @book = create :book
        @first_item = create :order_item, book: @book, quantity: 2
        @second_item = create :order_item, book: @book, quantity: 2
        @first_order = create :order, order_items: [@first_item]
        @second_order = create :order, order_items: [@second_item]
      end

      it 'update order_item quantity' do
        expect { @first_order.merge_order!(@second_order) }
          .to change { @first_item.reload.quantity }.by(2)
      end
      it 'update order total_price' do
        expect { @first_order.merge_order!(@second_order) }
          .to change { @first_order.reload.total_price }
      end
    end
    it 'return first_order' do
      @first_order = create :order, :with_items
      @second_order = create :order, :with_items
      expect(@first_order.merge_order!(@second_order)).to eq(@first_order)
    end
  end

  it '#sub_total' do
    items = create_list :order_item, 2, order: subject
    expect(subject.reload.sub_total).to eq(items.map(&:sub_total).sum)
  end

  it '#coupon_cost' do
    subject.coupon = build :coupon, discount: 50
    allow(subject).to receive(:sub_total).and_return(100)
    expect(subject.coupon_cost).to eq(-50.0)
  end

  describe '#calc_total_cost' do
    it 'without coupon' do
      expect(subject.calc_total_cost).to eq(subject.sub_total)
    end
    it 'with coupon' do
      allow(subject).to receive(:sub_total).and_return(30)
      allow(subject).to receive(:coupon_cost).and_return(-20)
      expect(subject.calc_total_cost(:coupon)).to eq(10)
    end
    it 'with coupon and delivery' do
      allow(subject).to receive(:sub_total).and_return(10)
      allow(subject).to receive(:coupon_cost).and_return(-20)
      allow(subject).to receive(:delivery_cost).and_return(20)
      expect(subject.calc_total_cost(:coupon, :delivery)).to eq(10)
    end
  end

  it '#access_deliveries' do
    country = create :country
    shipping = create :address_order, :shipping, country: country
    first_delivery = create :delivery, country: country
    second_delivery = create :delivery, country: country
    third_delivery = create :delivery
    allow(subject).to receive(:shipping).and_return(shipping)
    expect(subject.access_deliveries).to eq([first_delivery, second_delivery])
  end

  describe '#any_address?' do
    it 'when true' do
      shipping = create :address_order, :shipping, addressable: subject
      expect(subject.any_address?).to be_truthy
    end
    it 'when false' do
      subject.shipping = nil
      expect(subject.any_address?).to be_falsey
    end
  end

  context 'Before save' do
    it '#update_total_price' do
      subject.order_items = [create(:order_item)]
      expect { subject.save }.to change { subject.total_price }
    end
  end

  it '.not_empty' do
    order = create :order, order_items: [create(:order_item)]
    empty_order = create :order, order_items: []
    expect(Order.not_empty).not_to include(empty_order)
  end

end
