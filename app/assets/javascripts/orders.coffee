$(document).on "turbolinks:load", ->
  $('#filter_orders').change ->
    this.submit()

  $('.table-link').click ->
    window.document.location = $(this).data('href');
