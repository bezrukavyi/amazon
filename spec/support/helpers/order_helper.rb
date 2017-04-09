require_relative 'check_attributes_helper'
require_relative 'address_helper'
require_relative 'credit_card_helper'
require_relative 'delivery_helper'

module Support
  module Order
    include CheckAttributes
    include Address
    include CreditCard
    include Delivery

    def fill_order(form_id, values)
      values = [values] unless values.respond_to?(:each)
      within "##{form_id}" do
        values.each_with_index do |value, index|
          fill_in "order_order_items_attributes_#{index}_quantity", with: value
        end
        click_button I18n.t('carts.edit.update_cart')
      end
    end

    def fill_coupon(form_id, code)
      within "##{form_id}" do
        fill_in 'order_coupon_code', with: code
        click_button I18n.t('carts.edit.update_cart')
      end
    end

    def add_to_cart(form_id, quantity = nil)
      within "##{form_id}" do
        fill_in('quantity', with: quantity) if quantity.present?
        click_button I18n.t('add_to_cart')
      end
    end

    def choose_state(state)
      find('#order_types').click
      find('label', text: state).click
    end

    def check_order_info(order)
      order = order.decorate
      check_order_items(order)
      check_price(order, :sub_total)
      check_price(order, :completed_at)
      check_address(order.addresses)
      check_credit_card(order.credit_card)
      check_delivery(order.delivery)
    end

    def check_order_items(order)
      items = order.order_items
      books = items.map(&:book).map(&:decorate)
      check_title(items, :quantity)
      check_price(items, :sub_total)
      check_title(books)
      check_title(books, :short_desc)
      check_price(books)
    end
  end
end
