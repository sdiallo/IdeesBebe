# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $('.subdropdown .item').click ->
    id = $(this).children('#sub-id').attr('data-id')
    $('.category_id_field').val(id)


	