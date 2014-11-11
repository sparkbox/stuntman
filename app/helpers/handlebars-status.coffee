Ember.Handlebars.helper 'status', (status, options) ->
  return new Handlebars.SafeString "<img src='img/#{status}-bus.png'>"
