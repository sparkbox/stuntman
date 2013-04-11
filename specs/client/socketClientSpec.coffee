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
  describe "people management.", ->
    joe = gary = bob = null
    beforeEach ->
      joe = new socketPerson("Joe", 1)
      gary = new socketPerson("Gary", 2)
      bob = new socketPerson("Bob", 3)
      socketClient.addPerson(joe)
      socketClient.addPerson(gary)
      socketClient.addPerson(bob)
      return
    it "should have a person count of (5) after one local and four remote.", ->
      socketClient.addPerson(new socketPerson("James"))
      socketClient.addLocalPerson(new socketPerson("Me"))
      expect(socketClient.personCount).toBe(5)
    it "should allow you to remove a remote person by name.", ->
      expect(socketClient.personCount).toBe(3)
      socketClient.removePersonByName("Gary")
      expect(socketClient.personCount).toBe(2)
    it "should not remove a person if person is not found.", ->
      expect(socketClient.personCount).toBe(3)
      socketClient.removePersonByName("Smith")
      expect(socketClient.personCount).toBe(3)
    it "should allow you to remove a person by ID.", ->
      expect(socketClient.personCount).toBe(3)
      socketClient.removePersonById(1)
      expect(socketClient.personCount).toBe(2)
    it "should allow you to find a person by ID.", ->
      person = socketClient.getPersonById(1)
      expect(person.getName()).toBe("Joe")
    it "should allow you to find a person, 'Joe', by a name.", ->
      person = socketClient.getPersonByName("Joe")
      expect(person.getName()).toBe("Joe")
      expect(person.getName()).not.toBe("Gary")
