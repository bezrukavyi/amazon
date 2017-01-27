$(document).on "turbolinks:load", ->
  $('#use_billing').click ->
    $('#shipping_fields').slideToggle()

  $('input[name=delivery_id]').click ->
    checked_by_value($(this).attr('value'))
    delivery_item = $(this).closest('.delivery-item')
    delivery_order_subtotal = $('.delivery-order-subtotal', delivery_item).html()
    delivery_cost = $('.delivery-cost', delivery_item).html()
    $('#order_subtotal').html(delivery_order_subtotal)
    $('#order_delivery').html(delivery_cost)

  checked_by_value = (value) ->
    $("input[value=#{value}]").each( () -> this.checked = true )
