//@ sourceMappingURL=socketClientSpec.map
(function() {
  describe("Socket Client", function() {
    var socketClient, socketPerson;

    socketClient = null;
    socketPerson = null;
    beforeEach(function() {
      socketClient = new window.APP.SocketClient();
      socketPerson = window.APP.SocketPerson;
    });
    it("contains a constructable object", function() {
      expect(socketClient).not.toBeNull();
      return expect(typeof socketClient).not.toBeUndefined();
    });
    it("should contain an object of people", function() {
      expect(typeof socketClient.remotePeople).not.toBeUndefined();
      return expect(typeof socketClient.remotePeople).toBe("object");
    });
    it("should have a person count of 0", function() {
      return expect(socketClient.personCount).toBe(0);
    });
    it("should allow you to add a person", function() {
      socketClient.addPerson(new window.APP.SocketPerson());
      return expect(socketClient.personCount).toBe(1);
    });
    it("should allow you to create a local person", function() {
      socketClient.addLocalPerson(new window.APP.SocketPerson());
      expect(socketClient.localPerson).not.toBeNull();
      return expect(socketClient.personCount).toBe(1);
    });
    it("should have a person count of (2) after one local and one remote.", function() {
      socketClient.addPerson(new socketPerson("Joe"));
      socketClient.addLocalPerson(new socketPerson("Me"));
      return expect(socketClient.personCount).toBe(2);
    });
    it("should allow you to remove a remote person by name.", function() {
      socketClient.addPerson(new socketPerson("Joe"));
      socketClient.addPerson(new socketPerson("Gary"));
      expect(socketClient.personCount).toBe(2);
      socketClient.removePersonByName("Gary");
      return expect(socketClient.personCount).toBe(1);
    });
    it("should not remove a person if person is not found.", function() {
      socketClient.addPerson(new socketPerson("Joe"));
      socketClient.addPerson(new socketPerson("Gary"));
      expect(socketClient.personCount).toBe(2);
      socketClient.removePersonByName("Smith");
      return expect(socketClient.personCount).toBe(2);
    });
    return it("should allow you to remove a person by ID.", function() {
      var gary, joe;

      joe = new socketPerson("Joe", 1);
      gary = new socketPerson("Gary", 2);
      socketClient.addPerson(joe);
      socketClient.addPerson(gary);
      expect(socketClient.personCount).toBe(2);
      socketClient.removePersonById(1);
      return expect(socketClient.personCount).toBe(1);
    });
  });

}).call(this);
