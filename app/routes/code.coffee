`import Ember from 'ember'`

CodeRoute = Ember.Route.extend
  model: ->
    # @store.find 'code', '-J_o3D7qVreXPVm3Lill'
    "source": "jumpingBuses = ->\n  \"awesome!\"",
    "tests": "describe \"Stuntman\", ->\n  it \"should jump buses\", ->\n    expect(jumpingBuses()).toBe \"awesome!\"\n\n  it \"should jump buses\", ->\n    expect(jumpingBuses()).toBe \"awesome!aa\"\n\n"

`export default CodeRoute`
