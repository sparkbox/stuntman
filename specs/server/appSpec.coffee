usersById = require "../../app.coffee"
expect = require "expect.js"

describe "server testing", ->
   it "should work", ->
     expect(typeof usersById).to.be("object")