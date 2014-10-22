module.exports = App.IndexRoute = Ember.Route.extend
  model: ->
    @store.findAll 'test'
