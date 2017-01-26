$(document).on "turbolinks:load", ->
  $('#use_billing').click ->
    $('#shipping_fields').slideToggle()

  $('#delivery_form input[type=radio]').click ->
    delivery_item = $(this).closest('.delivery-item')
    delivery_order_subtotal = $('.delivery-order-subtotal', delivery_item).html()
    delivery_cost = $('.delivery-cost', delivery_item).html()
    $('#order_subtotal').html(delivery_order_subtotal)
    $('#order_delivery').html(delivery_cost)
