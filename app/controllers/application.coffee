module.exports = App.ApplicationController = Ember.Controller.extend
  actions:
    newScenario: ->
      console.log "new"

    save: ->
      console.log 'save record'
      @get('model').save()
