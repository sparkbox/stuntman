(function() {

  window.APP = {
    resultsTpl: Handlebars.compile($("#resultsTpl").html()),
    showResults: function(data) {
      return $("#results").html(APP.resultsTpl(data));
    },
    setRunner: function(runner) {
      APP.framework = runner;
      return localStorage["runner"] = runner;
    },
    runTests: function() {
      var $results;
      APP.iframe = $("#testRunner")[0].contentWindow;
      $results = $("#results");
      return APP.iframe.runTests($results[0]);
    },
    loadTests: function() {
      var $newFrame;
      $newFrame = $("<iframe id=\"testRunner\" class=\"hidden\" src=\"/test-frameworks/" + APP.framework + "/runner.html\"></iframe>").load(APP.runTests);
      return $("#testRunner").replaceWith($newFrame);
    },
    codeChange: function(name, editor) {
      localStorage[name] = editor.getValue();
      return APP.loadTests();
    },
    resultDisplayHelper: function(count) {
      var i, out, _i;
      out = "<output>";
      if (count > 0) {
        for (i = _i = 1; 1 <= count ? _i <= count : _i >= count; i = 1 <= count ? ++_i : --_i) {
          out += "◼ ";
        }
      }
      return out += "</output>";
    },
    setupCodeMirror: function() {
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
      return APP.srcMirror = CodeMirror(document.getElementById("source"), $.extend({}, cmOptions, {
        value: src
      }));
    },
    resizeEditors: function() {
      return $("#source, #tests").height($(window).height() - $("#source").position().top + "px");
    },
    common: {
      init: function() {
        APP.setupCodeMirror();
        Handlebars.registerHelper('resultGraphic', APP.resultDisplayHelper);
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
        APP.loadTests();
        return $(window).on("resize", APP.resizeEditors).resize();
      }
    }
  };

  $(document).ready(UTIL.loadEvents);

}).call(this);
