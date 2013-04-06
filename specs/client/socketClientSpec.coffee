describe "Socket Client", ->
  socketClient = null
  beforeEach ->
    socketClient = new window.APP.SocketClient()
    return
  it "contains a constructable object", ->
    expect(socketClient).not.toBeNull()
    expect(typeof socketClient).not.toBeUndefined()
  
