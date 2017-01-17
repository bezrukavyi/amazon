$(document).on "turbolinks:load", ->
  settings_type = window.location.hash.substr(1);

  activated_tab_by_hash = (hash) ->
    activated_link = document.getElementById("#{hash}_nav")
    $(activated_link).tab('show') if hash && activated_link

  activated_tab_by_hash(settings_type)

  $('.tab-link').click (e) ->
    $(this).tab('show')
    scrollmem = $('body').scrollTop() || $('html').scrollTop()
    window.location.hash = this.hash
    $('html,body').scrollTop(scrollmem)
