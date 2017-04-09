$(document).on "turbolinks:load", ->

  quantity_button = (button_class, type) ->
    $(button_class).click ->
      $field = $(this).closest('.quantity-field')
      old_value = $('.quantity-input', $field).val()
      new_value = 1

      if type == 'minus'
        new_value = parseInt(old_value) - 1
      if type == 'plus'
        new_value = parseInt(old_value) + 1

      if new_value > 0 && new_value < 99
        $('.quantity-input', $field).val(new_value)


  quantity_button('.quantity-minus', 'minus')
  quantity_button('.quantity-plus', 'plus')
