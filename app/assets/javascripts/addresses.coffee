$(document).on "turbolinks:load", ->

  setCodePlaceholder = (element, code) ->
    placeholder = $(element).attr('placeholder').replace(/\s\(\+\d+\)/, '')
    new_placeholder = "#{placeholder} (+#{code})" if code
    $(element).attr('placeholder', new_placeholder)

  $('.address-phone').each ->
    address_fields = $(this).closest('.address-fields')
    code = $('.select-country', address_fields).find(':selected').attr('data-code')
    setCodePlaceholder(this, code)

  $('.select-country').change ->
    code = $(this).find(':selected').attr('data-code')
    address_fields = $(this).closest('.address-fields')
    phone_field = $('.address-phone', address_fields)
    setCodePlaceholder(phone_field, code)
