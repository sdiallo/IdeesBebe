$ ->
  $('.subdropdown .item').click ->
    id = $(this).children('#sub-id').attr('data-id')
    $('.category_id_field').val(id)

  $('.upload-form').each (i, e) ->
    $(e).children().find('#photo_file').change ->
      form = $(this).parents('form')
      icon = form.children().find('.cloud')
      icon.removeClass('cloud upload').addClass('loading')
      form.submit()
      
	blueimp.Gallery document.getElementById("links").getElementsByTagName("a"),
    container: "#blueimp-product-carousel",
    carousel: true,
    stretchImages: true,
    thumbnailIndicators: true,
    thumbnailProperty: 'thumbnail'
    
  document.getElementById("links").onclick = (event) ->
    event = event or window.event
    target = event.target or event.srcElement
    link = (if target.src then target.parentNode else target)
    options =
      index: link
      event: event

    links = @getElementsByTagName("a")
    blueimp.Gallery links, options