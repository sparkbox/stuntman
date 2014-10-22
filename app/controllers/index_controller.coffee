module.exports = App.IndexController = Ember.ObjectController.extend

  index: () ->
    newTest = @store.createRecord 'test',
      source: '''
      window.jumpingBuses = ->
        "awesome!"
      '''
      tests: '''
      describe "Stuntman", ->
        it "should jump buses", ->
          expect(jumpingBuses()).toBe "awesome!"
      '''

    newTest.save()
