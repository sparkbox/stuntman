
/**
 * Module dependencies.
 */

var express = require('express')
  , routes = require('./routes')
  , user = require('./routes/user')
  , github = require('./routes/github')
  , everyauth = require('everyauth')
  , conf = require('./conf');
  // , http = require('http')
  // , path = require('path');

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
  .findOrCreateUser( function (sess, accessToken, accessTokenExtra, ghUser) {
      console.log( "find user" );
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


// app.use(express.static(__dirname + '/public'))
//   .use(express.favicon())
//   .use(express.bodyParser())
//   .use(express.cookieParser('htuayreve'))
//   .use(express.session())
//   .use(everyauth.middleware(app))
//   .use(app.router);

// app.configure( function () {
//   app.set('view engine', 'jade');
//   // app.set('views', everyauthRoot + '/example/views');
//   app.set('views', __dirname + '/views');
// });

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


// app.configure(function(){
//   app.set('port', process.env.PORT || 3000);
//   app.set('views', __dirname + '/views');
//   app.set('view engine', 'jade');
//   app.use(express.favicon());
//   app.use(express.logger('dev'));
//   app.use(express.bodyParser());
//   app.use(express.methodOverride());
//   app.use(express.cookieParser('whooohoooo!!'));
//   app.use(express.session({secret:'whooohoooo!!'}));
//   app.use(everyauth.middleware(app));
//   app.use(app.router);
//   app.use(require('stylus').middleware(__dirname + '/public'));
//   app.use(express.static(path.join(__dirname, 'public')));
// });

// app.configure('development', function(){
//   app.use(express.errorHandler());
// });

// app.get('/', routes.index);
// app.get('/users', user.list);
// app.get('/save', function(req, res){
//     /*console.log(req.session);*/
//     if(req.session.auth && req.session.auth.loggedIn){
//       res.render('private', {title: 'Protected'});
//     }else{
//       console.log("The user is NOT logged in");
//       /*console.log(req.session);*/
//       res.redirect('/');
//     }
// });


// http.createServer(app).listen(app.get('port'), function(){
//   console.log("Express server listening on port " + app.get('port'));
// });
