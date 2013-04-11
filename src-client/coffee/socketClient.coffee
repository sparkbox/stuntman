window.APP = window.APP || {}

class SocketClient
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
    if (removePerson = @getPersonByName(name))
      @remotePeople.splice(@remotePeople.indexOf(removePerson), 1)
      @personCount--
      return true
    return false
  removePersonById: (id) ->
    if (removePerson = @getPersonById(id))
      @remotePeople.splice(@remotePeople.indexOf(removePerson), 1)
      @personCount--
      return true
    return false
  getPersonById: (id) ->
    for person in @remotePeople
      if person.getId() == id
        return person
    return false
  getPersonByName: (name) ->
    for person in @remotePeople
      if person.getName() == name
        return person
    return false

#Expose to window
window.APP.SocketClient = SocketClient
