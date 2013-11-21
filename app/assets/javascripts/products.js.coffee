# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$(document).on 'click', '#asset_link .destroy_asset_link a', ->
  $("#asset_link .destroy_asset_link a").bind "ajax:success", (e, data, status, xhr) ->
    $("#asset_#{data.id}").hide(300)
    if data.new_id != null
      star_product = document.createElement("img")
      star_product.src = "/assets/product_star_thumb.jpg"
      star_product.alt = "Image principal"
      star_product.title = "Image principal"
      star_product.id = "img_star"
      $("#asset_link .star_product_#{data.new_id}").append star_product


$(document).on 'click', '#asset_link .star_asset_link a', ->
  $("#asset_link .star_asset_link a").bind "ajax:success", (e, data, status, xhr) ->
    if ($('#img_star').length > 0)
      $('#img_star').remove()
    star_product = document.createElement("img")
    star_product.src = "/assets/product_star_thumb.jpg"
    star_product.alt = "Image principal"
    star_product.title = "Image principal"
    star_product.id = "img_star"
    $("#asset_link .star_product_#{data.id}").append star_product
