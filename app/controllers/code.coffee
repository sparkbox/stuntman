module.exports = App.CodeController = Ember.ObjectController.extend

  testing: false

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
      localStorage.setItem('tests', @get('tests'))
      @set 'testing', true

