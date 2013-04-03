//@ sourceMappingURL=socketPersonSpec.map
(function() {
  describe("A Socket Person", function() {
    var socketPerson;

    socketPerson = null;
    beforeEach(function() {
      socketPerson = new window.APP.SocketPerson();
    });
    return it("allow you to construct a new person object", function() {
      expect(socketPerson).not.toBeNull();
      return expect(socketPerson).not.toBeUndefined();
    });
  });

}).call(this);
