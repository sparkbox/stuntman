
/**
 * Module dependencies.
 */

var express = require('express'),
    routes = require('./routes'),
    user = require('./routes/user'),
    github = require('./routes/github'),
    everyauth = require('everyauth'),
    conf = require('./conf');

var app = express();
var usersById = {};
var usersByGhId = {};
var nextUserId = 0;

everyauth.debug = true;

everyauth.everymodule
  .findUserById( function (id, callback) {
    callback(null, usersById[id]);
  });
  
everyauth.github
  .appId(conf.github.appId)
  .appSecret(conf.github.appSecret)
  .scope('gist')
  .findOrCreateUser( function (sess, accessToken, accessTokenExtra, ghUser) {
      console.log( "find user" );
      console.log(ghUser);
      return usersByGhId[ghUser.id] || (usersByGhId[ghUser.id] = addUser('github', ghUser));
  })
  .redirectPath('/');

function addUser (source, sourceUser) {
  var user;
  if (arguments.length === 1) { // password-based
    user = sourceUser = source;
    user.id = ++nextUserId;
    return usersById[nextUserId] = user;
  } else { // non-password-based
    user = usersById[++nextUserId] = {id: nextUserId};
    user[source] = sourceUser;
  }
  return user;
}

app.configure(function(){
  app.set('views', __dirname + '/views');
  app.set('view engine', 'jade');
  app.use(express.bodyParser());
  app.use(express.cookieParser());
  app.use(express.session({ secret: "secret" }));
  app.use(everyauth.middleware(app));
 
  app.use(express.methodOverride());
  app.use(app.router);
  app.use(express.static(__dirname + '/public'));
})

app.get('/', function (req, res) {
  res.render('index');
});

app.listen(3030);
console.log('Go to http://localhost:3030');