window.APP = window.APP || {}

window.APP.SocketClient = class SocketClient
  constructor: ->
    @remotePeople = []
    @personCount = 0
    @localPerson = null
  addPerson: (newPerson) ->
    if typeof newPerson is "object"
      @remotePeople.push(newPerson)
      @personCount++
  addLocalPerson: (localPerson) ->
    @localPerson = localPerson
    @personCount++
  removePersonByName: (name) ->
    for person in @remotePeople
      if person.getName() == name
        @remotePeople.splice(@remotePeople.indexOf(person), 1)
        @personCount--
        return
  removePersonById: (id) ->
    for person in @remotePeople
      if person.getId() == id
        @remotePeople.splice(@remotePeople.indexOf(person), 1)
        @personCount--
        return
