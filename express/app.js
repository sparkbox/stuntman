
/**
 * Module dependencies.
 */

var express = require('express'),
    routes = require('./routes'),
    user = require('./routes/user'),
    github = require('./routes/github'),
    https = require('https'),
    everyauth = require('everyauth'),
    conf = require('./conf'),
    cat = require('./octodex');

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
      console.log( "Token: " + accessToken );
      console.log(ghUser);
      return usersByGhId[ghUser.id] || (usersByGhId[ghUser.id] = addUser('github', ghUser, accessToken));
  })
  .redirectPath('/');

function addUser (source, sourceUser, token) {
  var user;
  if (arguments.length === 1) { // password-based
    user = sourceUser = source;
    user.id = ++nextUserId;
    return usersById[nextUserId] = user;
  } else { // non-password-based
    user = usersById[++nextUserId] = {id: nextUserId};
    user[source] = sourceUser;
    user['token'] = token;
  }
  return user;
}

function createGist( req ) {
  console.log( "Github Users:" );
  console.log( usersByGhId );
  req.body.user = "robtarr"
  req.body.access_token = usersByGhId['robtarr'].token
  console.log( req.body );
  var data = JSON.stringify( req.body ),
      opts = {
        host: "api.github.com",
        path: "/gists",
        method: "POST",
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Content-Length': data.length
        }
      },
      
      post_req = https.request( opts, function( res ) {
        res.setEncoding('utf8');
        res.on( 'data', function ( chunk ) {
          console.log( 'Response: ' + chunk) ;
        });
      });

  // post the data

  // post_req.write( data );
  // post_req.end();
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
  cat.octodex( function( randocat ) {
    res.render('index', { pageData: { cat: randocat } } );  
  });
});

app.post( '/creategist', function (req, res) {
  // console.log( everyauth.github.oauth );
  createGist( req )
});

app.listen(3030);
console.log('Go to http://localhost:3030');