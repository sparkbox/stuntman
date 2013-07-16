window.APP =
  
  showResults: ( data ) ->
    $results = $( "#results" )
    $results.html APP.resultsTpl data
    
    $results.find( "ul" ).toggleClass "show-more", data.failures.length > 1
      
  setRunner: ( runner ) ->
    APP.framework = runner
    localStorage["runner"] = runner

  runTests: ->
    APP.iframe = $( "#testRunner" )[0].contentWindow
    $results = $( "#results" )
    
    APP.iframe.runTests $results[0]
    
  loadTests: ->
    unless APP.error
      $newFrame = $( "<iframe id=\"testRunner\" class=\"hidden\" src=\"/test-frameworks/#{APP.framework}/runner.html\"></iframe>" ).load APP.runTests
      $( "#testRunner" ).replaceWith $newFrame
  
  codeToJS: ( code ) ->
    APP.error = false
    if APP.testMirror.getMode().name == "coffeescript"
      try
        code = CoffeeScript.compile code
        APP.error = false
      catch e
        APP.error = true
        $results = $( "#results" )
        $results.html APP.compilationErrorTpl 
          error: APP.editorErrorTpl e
      
    return code
  
  codeChange: ( name, editor ) ->
    # Store the code as written to redisplay on refresh
    localStorage[name] = editor.getValue()

    # Store the compiled code to pass to the test suite
    localStorage[name+"-modified"] = APP.codeToJS editor.getValue(), editor.getMode().name

    APP.loadTests()

  resultDisplayHelper: ( count ) ->
    out = "<output>"
    if count > 0
      for i in [1..count]
        out += "◼ "      
    out += "</output>"

  setupCodeMirror: ->
    cmOptions = 
      tabSize: 2
      theme: "monokai"
      lineNumbers: true
        
    tests = localStorage["tests"] || "describe \"Stuntman\", ->\n  it \"should jump buses\", ->\n    expect(jumpingBuses()).toBe \"awesome!\""
    src = localStorage["src"] || "window.jumpingBuses = ->\n  \"awesome!\""
    
    APP.testMirror = CodeMirror document.getElementById( "tests" ),
      $.extend(
        {},
        cmOptions,
        value: tests
      )
      
    APP.srcMirror = CodeMirror document.getElementById( "source" ),
      $.extend(
        {},
        cmOptions,
        value: src
      )
    APP.codeChange( "tests", APP.testMirror )
    APP.codeChange( "src", APP.srcMirror )
    
  resizeEditors: ->
    if $( "#source" ).position()
      $( "#source, #tests" ).height( $( window ).height() - $( "#source" ).position().top + "px");
  
  setEditorModes: ->
    APP.testMirror.setOption "mode", this.value
    APP.srcMirror.setOption "mode", this.value
    
    APP.codeChange "tests", APP.testMirror
    # APP.codeChange "src", APP.srcMirror
  
  fileExtension: ->
    if APP.testMirror.getMode().name is "coffeescript" then "coffee" else "js"
  
  saveGist: ->
    smoke.prompt "Please give a brief description:", ( desc ) ->
      files = {}
      files["test.#{APP.fileExtension()}"] = 
        content: APP.testMirror.getValue()
      files["source.#{APP.fileExtension()}"] =
        content: APP.srcMirror.getValue()
      
      newGist =
        description: desc
        public: true
        files: files
      
      $.ajax
        url: "/creategist"
        data: newGist
        type: 'POST'
        success: ->
          smoke.alert "Gist saved."

  loadGist: ( id ) ->
    $.ajax
      url: "https://api.github.com/gists/#{id}"
      success: ( data ) ->
        fileExtension = if data.files[ "test.coffee" ] then "coffee" else "js"
        APP.testMirror.setValue( data.files[ "test.#{fileExtension}" ].content )
        APP.srcMirror.setValue( data.files[ "source.#{fileExtension}" ].content )
  
  getGist: ->
    $.ajax
      url: "https://api.github.com/users/#{APP.githubUser}/gists"
      success: ( data ) ->
        APP.gists = APP.sortGists data

        smoke.alert( APP.gistsTpl( APP.gists ), ok: "Cancel" ) if APP.gists? and APP.gists.length > 0
        smoke.alert( APP.noGistsTpl(), ok: "Cancel" )
  
  sortGists: ( data ) ->
    data.filter ( gist ) -> gist if gist.files['source.coffee'] and gist.files['test.coffee'] 
  
  bindEvents: ->
    $( "#language" ).on( "change", APP.setEditorModes ).change()
      
    $( "#runner" ).on "change", ( e ) ->
      APP.setRunner this.value
      APP.loadTests()
    .val( localStorage[ "runner" ] ).change()
    
    $( "#save-gist" ).on "click", ->
      APP.saveGist()
    $( "#load-gist" ).on "click", ( e ) ->
      APP.getGist()
    
    if APP.testMirror
      APP.testMirror.on "change", ( editor ) ->
        APP.codeChange "tests", editor
    
    if APP.srcMirror
      APP.srcMirror.on "change", ( editor ) ->
        APP.codeChange "src", editor

    $( ".github-connect, #github-logout" ).on "click", ( e ) ->
      
      # e.preventDefault()
      # smoke.alert "We are experiencing some difficulty connecting to Github. Please try again later."
      
      $(@).addClass "githubStateChange"
      
    $( "body" ).on "click", ".user-gist", ( e ) ->
      e.preventDefault()
      APP.loadGist $(@).data "id"
      $( ".smoke-alert" ).remove()
  
  # Initializers
  common:
    init: ->
      APP.error = false
      APP.githubUser = $( "#load-gist" ).data( "name" )
        
      if $( "#resultsTpl" ).length
        APP.resultsTpl = Handlebars.compile $( "#resultsTpl" ).html()
      if $( "#compilationErrorTpl" ).length
        APP.compilationErrorTpl = Handlebars.compile $( "#compilationErrorTpl" ).html()
      if $( "#editorErrorTpl" ).length
        APP.editorErrorTpl = Handlebars.compile $( "#editorErrorTpl" ).html()
      if $( "#gistsTpl" ).length
        APP.gistsTpl = Handlebars.compile $( "#gistsTpl" ).html()

      if $( "#tests" ).length
        APP.setupCodeMirror()
      
      APP.bindEvents()
      
      Handlebars.registerHelper 'resultGraphic', APP.resultDisplayHelper
      
      APP.loadTests()
      
      $( window ).on( "resize", APP.resizeEditors ).resize()


$(document).ready UTIL.loadEvents