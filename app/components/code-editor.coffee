App.CodeEditorComponent = Ember.Component.extend
  init: ->
    @_super()
    Ember.defineProperty(this, 'value',
      Ember.computed.alias("model.#{@get('code')}")
    )

  _initializeEditor: (->
    textarea = document.getElementById(@elementId)
    editor = CodeMirror(textarea,
      tabSize: 2
      theme: "monokai"
      lineNumbers: true
      mode: ''
      lineWrapping: true
      value: @get('value')
    )

    editor.on 'change', (instance) =>
      Ember.run =>
        @set 'value', instance.getValue()
        window[@elementId] = instance.getValue()

    window["#{@get('editorID')}Editor"] = editor
  ).on('didInsertElement')
