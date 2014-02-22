<% if @updated == 'done' %>
  <% if @status.closed %> 
    $('.after-attached-label').show()
    cl = '.status_<%= raw @status.id %>'
    $(cl).dimmer('show')
  <% else %>
    $(cl).dimmer('hide')
    cl = '.status_<%= raw @status.id %>'
    $('.after-attached-label').fadeOut()
    $('.base-attached-label').fadeIn().css('z-index')
  <% end %>
<% else %>
  <% if @status.closed %>
    cl = '.status_<%= raw @status.id %>'
    $(cl).dimmer('show')
    $('.avalaible').hide()
    $('.closed').show()
  <% else %>
    cl = '.status_<%= raw @status.id %>'
    $(cl).dimmer('hide')
    $('.closed').hide()
    $('.avalaible').show()
  <% end %>
<% end %>
