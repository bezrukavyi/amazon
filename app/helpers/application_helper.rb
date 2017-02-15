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

  def message_wrap(key)
    content_tag :div, class: "alert alert-#{alert_class(key)}" do
      yield if block_given?
    end
  end

  def alert_class(key)
    case key
    when 'notice' then 'success'
    when 'alert' then 'warning'
    else key
    end
  end
end
