<% if @status.closed %>
  $('.closed-button').slideUp(200)
  $('.cant-respond').slideUp(200)
  $('#block-form-status-show').html("<%= j render 'status_closed' %>")
<% end %>
