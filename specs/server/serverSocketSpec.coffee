ServerSocket = require "../../serverSocket.coffee"
expect = require "expect.js"

serverSocket = new ServerSocket()

describe "Server Socket Class", ->
  it "should contain a constructable object", ->
    expect(typeof serverSocket).to.be("object")

