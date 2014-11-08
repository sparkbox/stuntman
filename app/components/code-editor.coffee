App.CodeEditorComponent = Ember.Component.extend
  init: ->
    @_super()
    Ember.defineProperty(this, 'value',
      Ember.computed.alias("model.#{@get('code')}")
    )

  _initializeEditor: (->
    textarea = document.getElementById(@elementId)
    @set 'editor', CodeMirror(textarea,
      tabSize: 2
      theme: "monokai"
      lineNumbers: true
      mode: ''
      lineWrapping: true
      value: @get('value')
    ).on 'change', (instance) =>
      Ember.run =>
        @set 'value', instance.getValue()
        debugger
        window[@elementId] = instance.getValue()

  ).on('didInsertElement')
