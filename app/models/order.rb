class Order < ApplicationRecord
  belongs_to :user
  belongs_to :delivery
  has_many :order_items, dependent: :destroy


  include AddressableRelation
  Address.address_types.keys.each do |type|
    has_address type
    accepts_nested_attributes_for type
  end

  include AASM

  aasm column: :state, whiny_transitions: false do
    state :in_progress, initial: true
    state :processing
    state :shipping
    state :delivered
    state :canceled

    event :confirm do
      transitions from: :in_progress, to: :processing
    end

    event :send_to_user do
      transitions from: :processing, to: :shipping
    end

    event :deliver do
      transitions from: :shipping, to: :delivered
    end

    event :cancel do
      transitions from: :processing, to: :canceled
    end
  end

end
