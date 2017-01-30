module ApplicationHelper

  def general_simple_form_for(path, options = {}, &block)
    options = options.deep_merge(html: { class: 'general-form' })
    simple_form_for(path, options, &block)
  end

  def currency_price(price)
    number_to_currency price, locale: :eu
  end

  def empty_cart_class
    'empty' if current_order.items_count.zero?
  end

end
