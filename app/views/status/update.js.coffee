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
    cl = '.status_<%= raw @status.id %>'
    $('.avalaible_<%= raw @status.id %>').hide()
    $('.closed_<%= raw @status.id %>').show()
    $(cl).dimmer('show')
    setTimeout ( ->
      $msg = $('.product-state.error')
      if $msg.length > 0
        $msg.slideToggle('200')
    ), 1000
  <% else %>
    cl = '.status_<%= raw @status.id %>'
    $('.closed_<%= raw @status.id %>').hide()
    $('.avalaible_<%= raw @status.id %>').show()
    $(cl).dimmer('hide')
    setTimeout ( ->
      $msg = $('.product-state.error')
      if $msg.length > 0
        $msg.slideToggle('200')
    ), 1000
  <% end %>
<% end %>
