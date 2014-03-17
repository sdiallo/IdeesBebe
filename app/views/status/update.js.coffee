<% if @updated == 'done' %>
  <% if @status.closed %> 
    $('.after-attached-label').show()
    $(cl).dimmer('show')
  <% else %>
    $(cl).dimmer('hide')
    $('.after-attached-label').fadeOut()
    $('.base-attached-label').fadeIn().css('z-index')
  <% end %>
<% else %>
  <% if @status.closed %>
    $('.closed-button').slideUp(200)
    $('.cant-respond').slideUp(200)
    $('#block-form-status-show').html("<%= j render 'status_closed' %>")
  <% else %>
    cl = '.status_<%= raw @status.id %>'
    $('.closed_<%= raw @status.id %>').hide(200)
    $('.avalaible_<%= raw @status.id %>').show()
    $(cl).dimmer('hide')
    setTimeout ( ->
      $msg = $('.product-state.error')
      if $msg.length > 0
        $msg.slideToggle('200')
    ), 1000
  <% end %>
<% end %>
