//@ sourceMappingURL=socketClientSpec.map
(function() {
  describe("Socket Client", function() {
    var socketClient;

    socketClient = null;
    beforeEach(function() {
      socketClient = new window.APP.SocketClient();
    });
    it("contains a constructable object", function() {
      expect(socketClient).not.toBeNull();
      return expect(typeof socketClient).not.toBeUndefined();
    });
    it("should contain an object of people", function() {
      expect(typeof socketClient.people).not.toBeUndefined();
      return expect(typeof socketClient.people).toBe("object");
    });
    it("should have a person count of 0", function() {
      return expect(socketClient.personCount).toBe(0);
    });
    return it("should allow you to add a person", function() {
      socketClient.addPerson(new window.APP.SocketPerson());
      return expect(socketClient.personCount).toBe(1);
    });
  });

}).call(this);
