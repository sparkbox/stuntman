module.exports = App.CodeController = Ember.ObjectController.extend

  selectedLanguage: null
  testing: false
  languageOptions: ['CoffeeScript', 'JavaScript']

  convertCode: (->
    if @get('selectedLanguage') is 'CoffeeScript'
      tests = @get('tests')
      window.testsEditor.setValue(js2coffee.build(tests))
      source = @get('source')
      window.sourceEditor.setValue(js2coffee.build(source))
    if @get('selectedLanguage') is 'JavaScript'
      tests = @get('tests')
      window.testsEditor.setValue(CoffeeScript.compile(tests,
        bare: true
      ))
      source = @get('source')
      window.sourceEditor.setValue(CoffeeScript.compile(source,
        bare: true
      ))

  ).observes('selectedLanguage')

  init: ->
    $(window).on 'storage', =>
      @set('testing', false)
      @set('results', JSON.parse(localStorage.getItem('testResults')))

  iFrameSrc: Ember.computed('testing', ->
    if @testing
      "/sandbox-jasmine.html"
    else
      ""
  ).property('testing')

  totalPassing: Ember.computed('results', ->
    if @get('results')
      @get('results').specCount - @get('results').failureCount
    else
      '-'
  ).property('results')

  totalFailing: Ember.computed('results', ->
    if @get('results')
      @get('results').failureCount
    else
      '-'
  ).property('results')

  displayList: Ember.computed('results', ->
    if @get('results')
      @get('results').statuses
  ).property('results')

  actions:
    test: ->
      @get('model').save()
      localStorage.setItem('language', @get('selectedLanguage'))
      localStorage.setItem('tests', @get('tests'))
      localStorage.setItem('source', @get('source'))
      @set 'testing', true

