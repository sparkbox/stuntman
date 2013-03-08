(function() {

  describe("Test App", function() {
    return describe("Results", function() {
      return describe("graphical display", function() {
        it("should no graphics for 0", function() {
          return APP.resultDisplayHelper(0).should === "<output></output>";
        });
        return it("should show 3 boxes for 3", function() {
          return APP.resultDisplayHelper(3).should === "<output>◼ ◼ ◼ </output>";
        });
      });
    });
  });

}).call(this);
