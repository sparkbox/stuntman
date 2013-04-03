describe "Socket Client", ->
  socketClient = null
  socketPerson = null
  beforeEach ->
    socketClient = new window.APP.SocketClient()
    socketPerson = window.APP.SocketPerson
    return
  it "contains a constructable object", ->
    expect(socketClient).not.toBeNull()
    expect(typeof socketClient).not.toBeUndefined()
  it "should contain an object of people", ->
    expect(typeof socketClient.remotePeople).not.toBeUndefined()
    expect(typeof socketClient.remotePeople).toBe("object")
  it "should have a person count of 0", ->
    expect( socketClient.personCount ).toBe(0)
  it "should allow you to add a person", ->
    socketClient.addPerson(new window.APP.SocketPerson())
    expect( socketClient.personCount ).toBe(1)
  it "should allow you to create a local person", ->
    socketClient.addLocalPerson(new window.APP.SocketPerson())
    expect(socketClient.localPerson).not.toBeNull()
    expect(socketClient.personCount).toBe(1)
  it "should have a person count of (2) after one local and one remote.", ->
    socketClient.addPerson(new socketPerson("Joe"))
    socketClient.addLocalPerson(new socketPerson("Me"))
    expect(socketClient.personCount).toBe(2)
  it "should allow you to remove a remote person by name.", ->
    socketClient.addPerson(new socketPerson("Joe"))
    socketClient.addPerson(new socketPerson("Gary"))
    expect(socketClient.personCount).toBe(2)
    socketClient.removePersonByName("Gary")
    expect(socketClient.personCount).toBe(1)
  it "should not remove a person if person is not found.", ->
    socketClient.addPerson(new socketPerson("Joe"))
    socketClient.addPerson(new socketPerson("Gary"))
    expect(socketClient.personCount).toBe(2)
    socketClient.removePersonByName("Smith")
    expect(socketClient.personCount).toBe(2)
  it "should allow you to remove a person by ID.", ->
    joe = new socketPerson("Joe", 1)
    gary = new socketPerson("Gary", 2)
    socketClient.addPerson(joe)
    socketClient.addPerson(gary)
    expect(socketClient.personCount).toBe(2)
    socketClient.removePersonById(1)
    expect(socketClient.personCount).toBe(1)
