App = require "../../app.coffee"
expect = require "expect.js"

app = new App()

describe "server testing", ->
  it "should work", ->
     expect(typeof app).to.be("object")
   it "should also work", ->
     expect(typeof app.usersById).to.be("object")
