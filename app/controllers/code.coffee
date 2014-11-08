module.exports = App.CodeController = Ember.ObjectController.extend

  actions:
    newCode: ->
      code = @store.createRecord 'code',
        source: 'new source code'
        tests: 'new tests'

      code.save()

    save: ->
      console.log 'save record'
      @get('model').save()
