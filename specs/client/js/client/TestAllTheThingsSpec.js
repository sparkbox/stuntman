//@ sourceMappingURL=TestAllTheThingsSpec.map
(function() {
  describe("Test App", function() {
    describe("Languages", function() {
      var $language, $tests;

      $tests = void 0;
      $language = void 0;
      describe("switching", function() {
        beforeEach(function() {
          $tests = affix("#tests").affix("#source");
          $language = affix("select#language");
          APP.setupCodeMirror();
          return APP.bindEvents();
        });
        it("will set the CodeMirror mode to Coffee when CS is selected from the language dropdown", function() {
          $language.affix("option[value=coffeescript]");
          $language.trigger("change");
          expect(APP.testMirror.getMode().name).toBe("coffeescript");
          return expect(APP.srcMirror.getMode().name).toBe("coffeescript");
        });
        return it("will set the CodeMirror mode to JavaScript when JS is selected from the language dropdown", function() {
          $language.affix("option[value=javascript]");
          $language.trigger("change");
          expect(APP.testMirror.getMode().name).toBe("javascript");
          return expect(APP.srcMirror.getMode().name).toBe("javascript");
        });
      });
      return it("can convert CoffeeScript tests to JavaScript", function() {
        APP.testMirror.setOption("mode", "coffeescript");
        APP.testMirror.setValue("test -> return true");
        return expect(APP.codeToJS(APP.testMirror.getValue())).toBe("(function() {\n\n" + "  test(function() {\n" + "    return true;\n" + "  });\n\n" + "}).call(this);\n");
      });
    });
    return describe("Results", function() {
      return describe("graphical display", function() {
        it("should no graphics for 0", function() {
          return expect(APP.resultDisplayHelper(0)).toBe("<output></output>");
        });
        return it("should show 3 boxes for 3", function() {
          return expect(APP.resultDisplayHelper(3)).toBe("<output>◼ ◼ ◼ </output>");
        });
      });
    });
  });

}).call(this);
