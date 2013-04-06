
###
Module dependencies.
###
addUser = (source, sourceUser) ->
  user = undefined
  if arguments.length is 1 # password-based
    user = sourceUser = source
    user.id = ++nextUserId
    return usersById[nextUserId] = user
  else # non-password-based
    user = usersById[++nextUserId] = id: nextUserId
    user[source] = sourceUser
  user
createGist = (data) ->
  github.gists.create data, (e, res) ->
    console.log res

express = require("express")
https = require("https")
GitHubApi = require("github")
everyauth = require("everyauth")
user = require("./routes/user")
github = require("./routes/github")
conf = require("./conf")
cat = require("./app/octodex")
app = express()
usersById = {}
usersByGhId = {}
nextUserId = 0
github = new GitHubApi(version: "3.0.0")

everyauth.everymodule.findUserById (id, callback) ->
  callback null, usersById[id]

everyauth.github.appId(conf.github.appId).appSecret(conf.github.appSecret).scope("gist").findOrCreateUser((sess, accessToken, accessTokenExtra, ghUser) ->
  github.authenticate
    type: "oauth"
    token: accessToken

  usersByGhId[ghUser.id] or (usersByGhId[ghUser.id] = addUser("github", ghUser))
).redirectPath "/"
app.configure ->
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



app.post "/creategist", (req, res) ->
  createGist req.body

app.listen 3030
console.log "Go to http://localhost:3030"
