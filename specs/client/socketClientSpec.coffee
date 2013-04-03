describe "Socket Client", ->
  socketClient = null
  beforeEach ->
    socketClient = new window.APP.SocketClient()
    return
  it "contains a constructable object", ->
    expect(socketClient).not.toBeNull()
    expect(typeof socketClient).not.toBeUndefined()
  it "should contain an object of people", ->
    expect(typeof socketClient.people).not.toBeUndefined()
    expect(typeof socketClient.people).toBe("object")
  it "should have a person count of 0", ->
    expect( socketClient.personCount ).toBe(0)
  it "should allow you to add a person", ->
    socketClient.addPerson(new window.APP.SocketPerson())
    expect( socketClient.personCount ).toBe(1)
  
