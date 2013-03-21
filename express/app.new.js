var express = require('express'),
  app = express(),
  http = require('http'),
  https = require('https'),
  connect = require('connect'),
  redis = require('connect-redis')(express),
  everyauth = require('everyauth'),
  sesh = new redis(),
  conf = require('./conf');

  everyauth.debug = true;
  
  everyauth.github
    .appId(conf.github.appId)
    .appSecret(conf.github.appSecret)
    .findOrCreateUser( function (session, accessToken, accessTokenExtra, githubUserMetadata) {
      session.oauth = accessToken;
      return session.uid = githubUserMetadata.login;
    })
    .redirectPath('/');
    
  everyauth.everymodule.handleLogout( function (req, res) {
    req.logout(); 
    req.session.uid = null;
    res.writeHead(303, { 'Location': this.logoutRedirectPath() });
    res.end();
  });
  
  app.configure(function(){
    app.set('view engine', 'jade');
    app.set('view options', {layout: false});
    app.use(express.bodyParser());
    app.use(express.cookieParser());
    app.use(express.session({store: sesh, secret: conf.redis.secret}));
    app.use(everyauth.middleware(app));
});
 
app.get('/',function(req,res) {
  res.render('login');
});

app.listen(process.env.PORT || 3030);