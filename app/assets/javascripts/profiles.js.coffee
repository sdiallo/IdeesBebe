$('.upload-avatar-block').children().find('#profile_avatar').change ->
  form = $(this).parents('form')
  icon = form.children().find('.cloud')
  icon.removeClass('cloud upload').addClass('loading')
  form.submit()
