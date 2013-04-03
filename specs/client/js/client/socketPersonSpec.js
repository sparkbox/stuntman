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
    return it("should be able to change the person name", function() {
      expect(socketPerson.name).toBe("");
      socketPerson.setName("Patrick");
      return expect(socketPerson.name).toBe("Patrick");
    });
  });

}).call(this);
