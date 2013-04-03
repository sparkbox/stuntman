describe "A Socket Person", ->
  socketPerson = null
  beforeEach ->
    socketPerson = new window.APP.SocketPerson()
    return
  it "should allow you to construct a new person object", ->
    expect(socketPerson).not.toBeNull()
    expect(socketPerson).not.toBeUndefined()
  it "should have a blank name by default", ->
    expect(socketPerson.name).toBe("")
  it "should allow you to set a name when creating a new person", ->
    socketPerson = new window.APP.SocketPerson("Patrick")
    expect(socketPerson.name).toBe("Patrick")
  it "should assign a person number of 0 by default", ->
    expect(socketPerson.getNumber()).toBe(0)
  it "should be able to change the person name", ->
    expect(socketPerson.name).toBe("")
    socketPerson.setName("Patrick")
    expect(socketPerson.name).toBe("Patrick")
  it "should have an ID field of null by default.", ->
    expect(socketPerson.id).toBeNull()
  it "should allow you to set an ID", ->
    socketPerson.setId(123)
    expect(socketPerson.id).toBe(123)
  it "should allow you to add an name and an ID in the constructor.", ->
    smith = new window.APP.SocketPerson("Smith", 2)
    expect(smith.getName()).toBe("Smith")
    expect(smith.getId()).toBe(2)
