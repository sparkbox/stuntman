###
Module dependencies.
###

express = require("express")
https = require("https")
GitHubApi = require("github")
everyauth = require("everyauth")
user = require("./routes/user")
github = require("./routes/github")
conf = require("./conf")
cat = require("./lib/octodex")

class App
  constructor: ->
    @express = null
    @usersById = {}
    @usersByGhId = {}
    @nextUserId = 0
    @github = new GitHubApi(version: "3.0.0")
    
    
  addUser: (source, sourceUser) ->
    user = @usersById[++@nextUserId] = id: @nextUserId
    user[source] = sourceUser

    return user
    
  createGist: (data) =>
    console.log data
    @github.gists.create data, (e, res) ->
      console.log e
      console.log res

  
  init: =>
    everyauth.everymodule.findUserById (id, callback) =>
      callback null, @usersById[id]

    everyauth.debug = true

    everyauth.github
      .appId(conf.github.appId)
      .appSecret(conf.github.appSecret)
      .scope("gist")
      .findOrCreateUser((sess, accessToken, accessTokenExtra, ghUser) =>
        @github.authenticate
          type: "oauth"
          token: accessToken
          
        @usersByGhId[ghUser.id] or (@usersByGhId[ghUser.id] = @addUser("github", ghUser)))
      .redirectPath "/"

    app = express()
    app.configure =>
      app.set "views", __dirname + "/views"
      app.set "view engine", "jade"
      app.use express.bodyParser()
      app.use express.cookieParser()
      app.use express.session(secret: "secret")
      app.use everyauth.middleware(app)
      app.use express.methodOverride()
      app.use app.router
      app.use express.static(__dirname + "/public")
      
    app.get "/", (req, res) ->
      cat.octodex (randocat) ->
        res.render "index",
          pageData:
            cat: randocat
            
    app.post "/creategist", (req, res) =>
      @createGist req.body

    app.listen 3030
    @express = app

app = new App()

app.init()

console.log "Go to http://localhost:3030"
module.exports = App
