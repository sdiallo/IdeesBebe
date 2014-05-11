$ ->
  $(".ui.dropdown").dropdown()

  if $('#blueimp-image-carousel').length > 0
    links = $('#links a')
    blueimp.Gallery links,
      container: '#blueimp-image-carousel',
      carousel: true,
      stretchImages: 'cover',
      thumbnailIndicators: true,
      thumbnailProperty: 'thumbnail'