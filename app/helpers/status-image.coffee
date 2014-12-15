`import Ember from 'ember';`

statusImage = Ember.Handlebars.makeBoundHelper (status, options) ->
  return new Handlebars.SafeString "<img src='img/#{status}-bus.png'>"

`export default statusImage;`
