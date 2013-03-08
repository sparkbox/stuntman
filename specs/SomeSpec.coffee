describe "Test App", ->
    
  describe "Results", ->
    
    describe "graphical display", ->
      it "should no graphics for 0", ->
        APP.resultDisplayHelper( 0 ).should == "<output></output>"
        
      it "should show 3 boxes for 3", ->
        APP.resultDisplayHelper( 3 ).should == "<output>◼ ◼ ◼ </output>" 