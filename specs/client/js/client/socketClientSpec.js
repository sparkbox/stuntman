//@ sourceMappingURL=socketClientSpec.map
(function() {
  describe("Socket Client", function() {
    var socketClient;

    socketClient = null;
    beforeEach(function() {
      socketClient = new window.APP.SocketClient();
    });
    return it("contains a constructable object", function() {
      expect(socketClient).not.toBeNull();
      return expect(typeof socketClient).not.toBeUndefined();
    });
  });

}).call(this);
