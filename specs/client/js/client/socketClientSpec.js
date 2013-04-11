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
    return describe("people management.", function() {
      var bob, gary, joe;

      joe = gary = bob = null;
      beforeEach(function() {
        joe = new socketPerson("Joe", 1);
        gary = new socketPerson("Gary", 2);
        bob = new socketPerson("Bob", 3);
        socketClient.addPerson(joe);
        socketClient.addPerson(gary);
        socketClient.addPerson(bob);
      });
      it("should have a person count of (5) after one local and four remote.", function() {
        socketClient.addPerson(new socketPerson("James"));
        socketClient.addLocalPerson(new socketPerson("Me"));
        return expect(socketClient.personCount).toBe(5);
      });
      it("should allow you to remove a remote person by name.", function() {
        expect(socketClient.personCount).toBe(3);
        socketClient.removePersonByName("Gary");
        return expect(socketClient.personCount).toBe(2);
      });
      it("should not remove a person if person is not found.", function() {
        expect(socketClient.personCount).toBe(3);
        socketClient.removePersonByName("Smith");
        return expect(socketClient.personCount).toBe(3);
      });
      it("should allow you to remove a person by ID.", function() {
        expect(socketClient.personCount).toBe(3);
        socketClient.removePersonById(1);
        return expect(socketClient.personCount).toBe(2);
      });
      it("should allow you to find a person by ID.", function() {
        var person;

        person = socketClient.getPersonById(1);
        return expect(person.getName()).toBe("Joe");
      });
      return it("should allow you to find a person, 'Joe', by a name.", function() {
        var person;

        person = socketClient.getPersonByName("Joe");
        expect(person.getName()).toBe("Joe");
        return expect(person.getName()).not.toBe("Gary");
      });
    });
  });

}).call(this);
