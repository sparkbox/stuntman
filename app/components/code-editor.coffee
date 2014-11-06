# App.CodeEditorComponent = Ember.Component.extend(
#   tagName: "textarea"

#   _initializeEditor: (->
#     codemirror = CodeMirror.fromTextArea(@$().get(0),
#       value: "test"
#       lineWrapping: true
#       lineNumbers: true
#       mode: ""
#       theme: "monokai"
#     )

#     codemirror.on "change", (instance) ->
#       Ember.run ->
#         @set "code", instance.getValue()

#     @set "editor", codemirror
#   ).on("didInsertElement")

#   updateValue: (->
#     @get("editor").setValue @get("code") if @get("editor").getValue() isnt @get("code")
#   ).observes("code")
# )


App.CodeEditorComponent = Ember.Component.extend
  init: ->
    @_super()
    Ember.Binding.from("model.#{@get('code')}").to('value').connect(@)

  content: (->
    console.log 'content change'
  ).property()

  setupFlags: (->
    textarea = document.getElementById(@elementId)
    @set @get('editorID'), CodeMirror(textarea,
      tabSize: 2
      theme: "monokai"
      lineNumbers: true
      mode: ''
      lineWrapping: true
      value: @get('value')
    ).on 'change', (instance) =>
      Ember.run =>
        @set 'value', instance.getValue()

  ).on('didInsertElement')
