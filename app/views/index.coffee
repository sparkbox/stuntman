App.IndexView = Ember.View.extend

  didInsertElement: ->

    setupCodeMirror = (->
      cmOptions =
        tabSize: 2
        theme: "monokai"
        lineNumbers: true

      testMirror = CodeMirror.fromTextArea "#tests",
        $.extend(
          {},
          cmOptions,
          value: tests
        )

      srcMirror = CodeMirror.fromTextArea "#source",
        $.extend(
          {},
          cmOptions,
          value: src
        )
    )()
