class Order < ApplicationRecord
  belongs_to :user
  belongs_to :delivery, optional: true
  belongs_to :credit_card, optional: true
  has_many :order_items, dependent: :destroy

  accepts_nested_attributes_for :order_items, allow_destroy: true

  include AddressableRelation
  Address.address_types.keys.each do |type|
    has_address type
    accepts_nested_attributes_for type
  end

  include AASM

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

  def add_item(book_id, quantity = 1)
    if item = order_items.find_by(book_id: book_id)
      item.increment :quantity, quantity
    else
      order_items.new(quantity: quantity, book_id: book_id)
    end
  end

end
