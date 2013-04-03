//@ sourceMappingURL=testAllTheThings.map
(function() {
  var SocketClient, SocketPerson;

  window.APP = {
    showResults: function(data) {
      var $results;

      $results = $("#results");
      $results.html(APP.resultsTpl(data));
      return $results.find("ul").toggleClass("show-more", data.failures.length > 1);
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

      if (!APP.error) {
        $newFrame = $("<iframe id=\"testRunner\" class=\"hidden\" src=\"/test-frameworks/" + APP.framework + "/runner.html\"></iframe>").load(APP.runTests);
        return $("#testRunner").replaceWith($newFrame);
      }
    },
    codeToJS: function(code) {
      var e;

      if (APP.testMirror.getMode().name === "coffeescript") {
        try {
          code = CoffeeScript.compile(code);
          APP.error = false;
        } catch (_error) {
          e = _error;
          $("#results").html(APP.editorErrorTpl(e));
          APP.error = true;
        }
      }
      return code;
    },
    codeChange: function(name, editor) {
      localStorage[name] = editor.getValue();
      localStorage[name + "-modified"] = APP.codeToJS(editor.getValue(), editor.getMode().name);
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
    setEditorModes: function() {
      APP.testMirror.setOption("mode", this.value);
      APP.srcMirror.setOption("mode", this.value);
      return APP.codeChange("tests", APP.testMirror);
    },
    fileExtension: function() {
      if (APP.testMirror.getMode().name === "coffeescript") {
        return "coffee";
      } else {
        return "js";
      }
    },
    saveGist: function() {
      return smoke.prompt("Please give a brief description:", function(desc) {
        var files, newGist;

        files = {};
        files["test." + (APP.fileExtension())] = APP.testMirror.getValue();
        files["source." + (APP.fileExtension())] = APP.srcMirror.getValue();
        newGist = {
          description: desc,
          "public": true,
          files: files
        };
        console.log(newGist);
        return $.ajax({
          url: "/creategist",
          data: newGist,
          type: 'POST',
          success: function() {
            return alert("Gist saved.");
          }
        });
      });
    },
    loadGist: function(id) {
      return $.ajax({
        url: "https://api.github.com/gists/" + id,
        success: function(data) {
          var fileExtension;

          fileExtension = data.files["test.coffee"] ? "coffee" : "js";
          APP.testMirror.setValue(data.files["test." + fileExtension].content);
          return APP.srcMirror.setValue(data.files["source." + fileExtension].content);
        }
      });
    },
    getGist: function() {
      return smoke.prompt("Enter a Gist ID:", function(id) {
        return APP.loadGist(id);
      });
    },
    bindEvents: function() {
      $("#language").on("change", APP.setEditorModes).change();
      $("#runner").on("change", function(e) {
        APP.setRunner(this.value);
        return APP.loadTests();
      }).val(localStorage["runner"]).change();
      $("#save-gist").on("click", function() {
        return APP.saveGist();
      });
      $("#load-gist").on("click", function(e) {
        return APP.getGist();
      });
      APP.testMirror.on("change", function(editor) {
        return APP.codeChange("tests", editor);
      });
      return APP.srcMirror.on("change", function(editor) {
        return APP.codeChange("src", editor);
      });
    },
    common: {
      init: function() {
        APP.error = false;
        APP.resultsTpl = Handlebars.compile($("#resultsTpl").html());
        APP.editorErrorTpl = Handlebars.compile($("#editorErrorTpl").html());
        APP.gistsTpl = Handlebars.compile($("#gistsTpl").html());
        APP.setupCodeMirror();
        APP.bindEvents();
        Handlebars.registerHelper('resultGraphic', APP.resultDisplayHelper);
        APP.loadTests();
        return $(window).on("resize", APP.resizeEditors).resize();
      }
    }
  };

  $(document).ready(UTIL.loadEvents);

  window.APP = window.APP || {};

  window.APP.SocketClient = SocketClient = (function() {
    function SocketClient() {
      this.people = [];
      this.personCount = 0;
    }

    SocketClient.prototype.addPerson = function(newPerson) {
      if (typeof newPerson === "object") {
        this.people.push(newPerson);
        return this.personCount++;
      }
    };

    return SocketClient;

  })();

  window.APP = window.APP || {};

  window.APP.SocketPerson = SocketPerson = (function() {
    function SocketPerson() {}

    return SocketPerson;

  })();

}).call(this);
