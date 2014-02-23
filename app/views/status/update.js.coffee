
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
  <% else %>
    cl = '.status_<%= raw @status.id %>'
    $('.closed_<%= raw @status.id %>').hide()
    $('.avalaible_<%= raw @status.id %>').show()
    $(cl).dimmer('hide')
  <% end %>
<% end %>
