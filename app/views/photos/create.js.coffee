$(".upload_<%= @index %>").replaceWith("<%= j render(partial: 'photos/edit_photo', locals: { photo: @asset }) %>")