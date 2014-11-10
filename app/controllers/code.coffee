module.exports = App.CodeController = Ember.ObjectController.extend

  testing: false

  iFrameSrc: Ember.computed 'testing', ->
    if @testing
      "sandbox-jasmine.html"
    else
      "empty"

  actions:
    newCode: ->
      code = @store.createRecord 'code',
        source: 'new source code'
        tests: 'new tests'

      code.save()

    test: ->
      @get('model').save()
      # iFrameSrc.set 'sandbox-jasmine.html'
