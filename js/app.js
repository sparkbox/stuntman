(function() {

  window.APP = {
    $testRunner: $($("#testRunner")[0].contentWindow.document),
    setupTests: function() {
      var reporter;
      APP.iframe = $("#testRunner")[0].contentWindow;
      APP.jasmineEnv = APP.iframe.jasmine.getEnv();
      APP.jasmineEnv.updateInterval = 1000;
      reporter = new APP.iframe.jasmine.TrivialReporter({
        location: window.document.location,
        body: $("#results")[0]
      });
      return APP.jasmineEnv.addReporter(reporter);
    },
    runTests: function() {
      APP.setupTests();
      APP.iframe.loadJS();
      $("#results").html("");
      return APP.jasmineEnv.execute();
    },
    loadTests: function() {
      var $newFrame;
      $newFrame = $("<iframe id=\"testRunner\" src=\"jasmine-runner.html\"></iframe>").load(APP.runTests);
      return $("#testRunner").replaceWith($newFrame);
    },
    storeJS: function(name, editor) {
      return localStorage[name] = editor.getValue();
    },
    common: {
      init: function() {
        var cmOptions, src, tests;
        cmOptions = {
          tabSize: 2,
          theme: "monokai"
        };
        tests = localStorage["tests"] || "describe('jsTesting', function() {\n  it(\"should pass\", function() {\n    expect( true ).toBe( true );\n  })\n});";
        src = localStorage["src"] || "function myScript(){return 100;}\n";
        APP.testMirror = CodeMirror(document.getElementById("tests"), $.extend({}, cmOptions, {
          value: tests
        }));
        APP.srcMirror = CodeMirror(document.getElementById("source"), $.extend({}, cmOptions, {
          value: src
        }));
        APP.testMirror.on("change", function(e) {
          APP.storeJS("tests", e);
          return APP.loadTests();
        });
        return APP.srcMirror.on("change", function(e) {
          APP.storeJS("src", e);
          return APP.loadTests();
        });
      }
    }
  };

  $(document).ready(UTIL.loadEvents);

}).call(this);
