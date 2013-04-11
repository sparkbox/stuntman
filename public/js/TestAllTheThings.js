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
      if ($("#source").position()) {
        return $("#source, #tests").height($(window).height() - $("#source").position().top + "px");
      }
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
      if (APP.testMirror) {
        APP.testMirror.on("change", function(editor) {
          return APP.codeChange("tests", editor);
        });
      }
      if (APP.srcMirror) {
        return APP.srcMirror.on("change", function(editor) {
          return APP.codeChange("src", editor);
        });
      }
    },
    common: {
      init: function() {
        APP.error = false;
        if ($("#resultsTpl").length) {
          APP.resultsTpl = Handlebars.compile($("#resultsTpl").html());
        }
        if ($("#editorErrorTpl").length) {
          APP.editorErrorTpl = Handlebars.compile($("#editorErrorTpl").html());
        }
        if ($("#gistsTpl").length) {
          APP.gistsTpl = Handlebars.compile($("#gistsTpl").html());
        }
        if ($("#tests").length) {
          APP.setupCodeMirror();
        }
        APP.bindEvents();
        Handlebars.registerHelper('resultGraphic', APP.resultDisplayHelper);
        APP.loadTests();
        return $(window).on("resize", APP.resizeEditors).resize();
      }
    }
  };

  $(document).ready(UTIL.loadEvents);

  window.APP = window.APP || {};

  SocketClient = (function() {
    function SocketClient() {
      this.remotePeople = [];
      this.personCount = 0;
      this.localPerson = null;
    }

    SocketClient.prototype.addPerson = function(newPerson) {
      if (typeof newPerson === "object") {
        this.remotePeople.push(newPerson);
        return this.personCount++;
      }
    };

    SocketClient.prototype.addLocalPerson = function(localPerson) {
      this.localPerson = localPerson;
      return this.personCount++;
    };

    SocketClient.prototype.removePersonByName = function(name) {
      var removePerson;

      if ((removePerson = this.getPersonByName(name))) {
        this.remotePeople.splice(this.remotePeople.indexOf(removePerson), 1);
        this.personCount--;
        return true;
      }
      return false;
    };

    SocketClient.prototype.removePersonById = function(id) {
      var removePerson;

      if ((removePerson = this.getPersonById(id))) {
        this.remotePeople.splice(this.remotePeople.indexOf(removePerson), 1);
        this.personCount--;
        return true;
      }
      return false;
    };

    SocketClient.prototype.getPersonById = function(id) {
      var person, _i, _len, _ref;

      _ref = this.remotePeople;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        person = _ref[_i];
        if (person.getId() === id) {
          return person;
        }
      }
      return false;
    };

    SocketClient.prototype.getPersonByName = function(name) {
      var person, _i, _len, _ref;

      _ref = this.remotePeople;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        person = _ref[_i];
        if (person.getName() === name) {
          return person;
        }
      }
      return false;
    };

    return SocketClient;

  })();

  window.APP.SocketClient = SocketClient;

  window.APP = window.APP || {};

  SocketPerson = (function() {
    function SocketPerson(name, id) {
      if (name == null) {
        name = "";
      }
      if (id == null) {
        id = null;
      }
      this.name = name;
      this.number = 0;
      this.id = id;
    }

    SocketPerson.prototype.getNumber = function() {
      return this.number;
    };

    SocketPerson.prototype.getName = function() {
      return this.name;
    };

    SocketPerson.prototype.setNumber = function(n) {
      return this.number = n;
    };

    SocketPerson.prototype.setName = function(name) {
      return this.name = name;
    };

    SocketPerson.prototype.setId = function(id) {
      return this.id = id;
    };

    SocketPerson.prototype.getId = function() {
      return this.id;
    };

    return SocketPerson;

  })();

  window.APP.SocketPerson = SocketPerson;

}).call(this);
