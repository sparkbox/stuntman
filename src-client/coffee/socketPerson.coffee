window.APP = window.APP || {}

window.APP.SocketPerson = class SocketPerson
  constructor: (name = "") ->
    @name = name
    @number = 0
  getNumber: ->
    @number
  getName: ->
    @name
  setNumber: (n) ->
    @number = n
  setName: (name) ->
    @name = name
  
