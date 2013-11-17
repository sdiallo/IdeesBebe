# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'click', '.destroy_avatar_link a', ->
  $(".destroy_avatar_link a").bind "ajax:success", (e, data, status, xhr) ->
    $("#avatar").hide(300)