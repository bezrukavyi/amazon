$(document).on "turbolinks:load", ->
  $('#filter_book').change ->
    this.submit()
