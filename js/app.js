(function() {

  window.APP = {
    $testRunner: $($("#testRunner")[0].contentWindow.document),
    resultsTpl: Handlebars.compile($("#resultsTpl").html()),
    framework: 'qunit',
    showResults: function(data) {
      console.log(data);
      return $("#results").html(APP.resultsTpl(data));
    },
    setRunner: function(runner) {
      APP.framework = runner;
      return localStorage["runner"] = runner;
    },
    runTests: function() {
      APP.iframe = $("#testRunner")[0].contentWindow;
      $("#results").html("");
      return APP.iframe.runTests($("#results")[0]);
    },
    loadTests: function() {
      var $newFrame;
      $newFrame = $("<iframe id=\"testRunner\" src=\"/test-frameworks/" + APP.framework + "/runner.html\"></iframe>").load(APP.runTests);
      return $("#testRunner").replaceWith($newFrame);
    },
    codeChange: function(name, editor) {
      localStorage[name] = editor.getValue();
      return APP.loadTests();
    },
    common: {
      init: function() {
        var cmOptions, src, tests;
        cmOptions = {
          tabSize: 2,
          theme: "monokai",
          lineNumbers: true
        };
        tests = localStorage["tests"] || "describe('jsTesting', function() {\n  it(\"should pass\", function() {\n    expect( true ).toBe( true );\n  })\n});";
        src = localStorage["src"] || "function myScript(){return 100;}\n";
        APP.testMirror = CodeMirror(document.getElementById("tests"), $.extend({}, cmOptions, {
          value: tests
        }));
        APP.srcMirror = CodeMirror(document.getElementById("source"), $.extend({}, cmOptions, {
          value: src
        }));
        APP.testMirror.on("change", function(editor) {
          return APP.codeChange("tests", editor);
        });
        APP.srcMirror.on("change", function(editor) {
          return APP.codeChange("src", editor);
        });
        $("#runner").on("change", function(e) {
          APP.setRunner(this.value);
          return APP.loadTests();
        }).val(localStorage["runner"]).change();
        return APP.loadTests();
      }
    }
  };

  $(document).ready(UTIL.loadEvents);

}).call(this);
