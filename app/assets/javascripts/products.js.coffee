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
	