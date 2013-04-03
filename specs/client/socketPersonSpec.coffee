describe "A Socket Person", ->
  socketPerson = null
  beforeEach ->
    socketPerson = new window.APP.SocketPerson()
    return
  it "allow you to construct a new person object", ->
    expect(socketPerson).not.toBeNull()
    expect(socketPerson).not.toBeUndefined()
