$(document).on "turbolinks:load", ->
  $('#filter_book').change ->
    this.submit()

  $('.desc_button').click ->
    $('.description-block').toggleClass('active')

  $('.bonus-picture').click ->
    $main_picture = $('#main-picture')
    bonus_img = $(this).attr('src')
    $(this).attr('src', $main_picture.attr('src'))
    $main_picture.attr('src', bonus_img)
