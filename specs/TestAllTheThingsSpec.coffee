describe "Test App", ->
    
  describe "Languages", ->
    $tests = undefined
    $language = undefined
    
    describe "switching", ->
      beforeEach ->
        $tests = affix( "#tests" ).affix( "#source" )
        $language = affix "select#language"
        APP.setupCodeMirror()
        APP.bindEvents()
                
      it "will set the CodeMirror mode to Coffee when CS is selected from the language dropdown", ->
    
        $language.affix "option[value=coffeescript]"
        $language.trigger "change"
      
        expect( APP.testMirror.getMode().name ).toBe( "coffeescript" )
        expect( APP.srcMirror.getMode().name ).toBe( "coffeescript" )
        
      it "will set the CodeMirror mode to JavaScript when JS is selected from the language dropdown", ->
        
        $language.affix "option[value=javascript]"
        $language.trigger "change"
        
        expect( APP.testMirror.getMode().name ).toBe( "javascript" )
        expect( APP.srcMirror.getMode().name ).toBe( "javascript" )

    it "can convert CoffeeScript tests to JavaScript", ->

      APP.testMirror.setOption "mode", "coffeescript"
      APP.testMirror.setValue "test -> return true"
      
      expect( APP.codeToJS APP.testMirror.getValue() ).toBe "(function() {\n\n"+
      "  test(function() {\n"+
      "    return true;\n"+
      "  });\n\n"+
      "}).call(this);\n"

  describe "Results", ->
    
    describe "graphical display", ->
      it "should no graphics for 0", ->
        expect( APP.resultDisplayHelper( 0 )).toBe "<output></output>"
        
      it "should show 3 boxes for 3", ->
        expect( APP.resultDisplayHelper( 3 )).toBe "<output>◼ ◼ ◼ </output>"