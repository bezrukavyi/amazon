require_relative 'order_helper'
require_relative 'address_helper'
require_relative 'credit_card_helper'
require_relative 'delivery_helper'

module Support
  module Checkout
    include Order
    include Address
    include CreditCard
    include Delivery

    def check_confirm_step(order)
      order = order.decorate
      check_order_items(order)
      check_price(order, :sub_total)
      check_price(order, :completed_at)
      check_address(order.addresses)
      check_credit_card(order.credit_card)
      check_delivery(order.delivery)
    end
  end
end
