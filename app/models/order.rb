class Order < ApplicationRecord
  include AddressableRelation
  include AASM

  belongs_to :user
  belongs_to :delivery, optional: true
  belongs_to :credit_card, optional: true
  has_many :order_items, dependent: :destroy
  has_one :coupon

  accepts_nested_attributes_for :order_items, allow_destroy: true
  accepts_nested_attributes_for :credit_card

  Address::TYPES.each do |type|
    has_address type
    accepts_nested_attributes_for type
  end

  before_save :update_total_price

  scope :with_items_book, -> { includes(order_items: :book) }

  aasm column: :state, whiny_transitions: false do
    state :processing, initial: true
    state :in_progress
    state :in_delivery
    state :delivered
    state :canceled

    event :confirm do
      transitions from: :processing, to: :in_progress
    end

    event :send_to_user do
      transitions from: :in_progress, to: :in_delivery
    end

    event :deliver do
      transitions from: :in_delivery, to: :delivered
    end

    event :cancel do
      transitions from: :in_progress, to: :canceled
    end
  end

  def sub_total
    order_items.map(&:sub_total).sum
  end

  def coupon_cost
    coupon ? sub_total * coupon.discount * -0.01 : 0.00
  end

  def delivery_cost
    delivery ? delivery.price : 0.00
  end

  def calc_total_cost(*additions)
    sub_total + additions.map { |addition| send("#{addition}_cost") }.sum
  end

  def access_deliveries
    return unless shipping
    @access_deliveries ||= Delivery.where(country: shipping.country)
  end

  def addresses
    [shipping, billing]
  end

  def any_address?
    shipping || billing
  end

  def items_count
    @items_count ||= order_items.map(&:quantity).sum
  end

  def add_item(book_id, quantity = 1)
    if item = order_items.find_by(book_id: book_id)
      item.increment :quantity, quantity
    else
      order_items.new(quantity: quantity, book_id: book_id)
    end
  end

  def merge_order!(order)
    return self if self == order
    order.order_items.each do |order_item|
      add_item(order_item.book_id, order_item.quantity).save
    end
    tap(&:save)
  end

  private

  def update_total_price
    self.total_price = calc_total_cost(:coupon, :delivery)
  end

end
