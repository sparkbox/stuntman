//@ sourceMappingURL=socketPersonSpec.map
(function() {
  describe("A Socket Person", function() {
    var socketPerson;

    socketPerson = null;
    beforeEach(function() {
      socketPerson = new window.APP.SocketPerson();
    });
    it("should allow you to construct a new person object", function() {
      expect(socketPerson).not.toBeNull();
      return expect(socketPerson).not.toBeUndefined();
    });
    it("should have a blank name by default", function() {
      return expect(socketPerson.name).toBe("");
    });
    it("should allow you to set a name when creating a new person", function() {
      socketPerson = new window.APP.SocketPerson("Patrick");
      return expect(socketPerson.name).toBe("Patrick");
    });
    it("should assign a person number of 0 by default", function() {
      return expect(socketPerson.getNumber()).toBe(0);
    });
    it("should be able to change the person name", function() {
      expect(socketPerson.name).toBe("");
      socketPerson.setName("Patrick");
      return expect(socketPerson.name).toBe("Patrick");
    });
    it("should have an ID field of null by default.", function() {
      return expect(socketPerson.id).toBeNull();
    });
    it("should allow you to set an ID", function() {
      socketPerson.setId(123);
      return expect(socketPerson.id).toBe(123);
    });
    return it("should allow you to add an name and an ID in the constructor.", function() {
      var smith;

      smith = new window.APP.SocketPerson("Smith", 2);
      expect(smith.getName()).toBe("Smith");
      return expect(smith.getId()).toBe(2);
    });
  });

}).call(this);
