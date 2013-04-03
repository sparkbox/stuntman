window.APP = window.APP || {}

window.APP.SocketClient = class SocketClient
  constructor: ->
    @people = []
    @personCount = 0
  addPerson: (newPerson) ->
    if typeof newPerson is "object"
      @people.push(newPerson)
      @personCount++
