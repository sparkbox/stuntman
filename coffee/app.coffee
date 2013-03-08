window.APP =
  
  resultsTpl: Handlebars.compile $( "#resultsTpl" ).html()

  showResults: ( data ) ->
    $( "#results" ).html APP.resultsTpl data
 
  setRunner: ( runner ) ->
    APP.framework = runner
    localStorage["runner"] = runner

  runTests: ->
    APP.iframe = $( "#testRunner" )[0].contentWindow
    $results = $( "#results" )
    
    APP.iframe.runTests $results[0]
    
  loadTests: ->
    $newFrame = $( "<iframe id=\"testRunner\" class=\"hidden\" src=\"/test-frameworks/#{APP.framework}/runner.html\"></iframe>" ).load APP.runTests
    $( "#testRunner" ).replaceWith $newFrame
  
  codeChange: ( name, editor ) ->
    localStorage[name] = editor.getValue()
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
      
    tests = localStorage["tests"] || "describe('jsTesting', function() {\n  it(\"should pass\", function() {\n    expect( true ).toBe( true );\n  })\n});"
    src = localStorage["src"] || "function myScript(){return 100;}\n"
    
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

  resizeEditors: ->
    $( "#source, #tests" ).height( $( window ).height() - $( "#source" ).position().top + "px");  
  
  # Initializers
  common:
    init: ->
      APP.setupCodeMirror()
      
      Handlebars.registerHelper 'resultGraphic', APP.resultDisplayHelper
      
      APP.testMirror.on "change", ( editor ) ->
        APP.codeChange "tests", editor
      APP.srcMirror.on "change", ( editor ) ->
        APP.codeChange "src", editor
        
      $( "#runner" ).on "change", ( e ) ->
        APP.setRunner this.value
        APP.loadTests()
      .val( localStorage[ "runner" ] ).change()
        
      APP.loadTests()
      
      $( window ).on( "resize", APP.resizeEditors ).resize()
        
$(document).ready UTIL.loadEvents