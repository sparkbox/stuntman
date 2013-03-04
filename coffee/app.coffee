window.APP =
  
  $testRunner: $( $( "#testRunner" )[0].contentWindow.document )
  
  setupTests: ->
    APP.iframe = $( "#testRunner" )[0].contentWindow
    
    APP.jasmineEnv = APP.iframe.jasmine.getEnv()
    APP.jasmineEnv.updateInterval = 1000

    reporter = new APP.iframe.jasmine.TrivialReporter
      location: window.document.location
      body: $( "#results" )[0]

    APP.jasmineEnv.addReporter reporter

  runTests: ->
    APP.setupTests()
    APP.iframe.loadJS()
    
    $( "#results" ).html( "" )
    APP.jasmineEnv.execute()
    
  loadTests: ->
    $newFrame = $( "<iframe id=\"testRunner\" src=\"jasmine-runner.html\"></iframe>" ).load APP.runTests
      
    $( "#testRunner" ).replaceWith( $newFrame )
    # setTimeout APP.runTests, 500
    
  storeJS: ( name, editor )->
    localStorage[name] = editor.getValue()

  # Initializers
  common:
    init: ->
      cmOptions = 
        tabSize: 2
        theme: "monokai"
        # lineNumbers: true
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
        
      APP.testMirror.on "change", ( e ) ->
        APP.storeJS( "tests", e )
        APP.loadTests()
        
      APP.srcMirror.on "change", ( e ) ->
        APP.storeJS( "src", e )
        APP.loadTests()
        
$(document).ready UTIL.loadEvents