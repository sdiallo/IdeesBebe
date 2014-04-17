<% if @error %>
  $(".upload-form").html("<%= j render(partial: 'profiles/form_avatar', locals: { profile: @profile, user: @user }) %>")
  $(".upload-form").after('<div style="text-align: center; margin-top: 10px">Fichier invalide</div>')
<% else %>
  $(".upload-form").html("<%= j render(partial: 'profiles/edit_avatar', locals: { profile: @profile, user: @user }) %>")
<% end %>