//@ sourceMappingURL=app.map
(function() {
  var GitHubApi, addUser, app, cat, conf, createGist, everyauth, express, github, https, jsdom, nextUserId, routes, user, usersByGhId, usersById;

  module.exports = {
    github: {
      appId: "5a6dc8e8391d4ca83f2e",
      appSecret: "0a2cef0f11c8417e7f3ae69ce3cdd02243cbb322"
    },
    redis: {
      secret: "234059872345908723459087"
    }
  };

  jsdom = require("jsdom");

  exports.octodex = function(callback) {
    return jsdom.env("http://octodex.github.com/", ["http://code.jquery.com/jquery.js"], function(errors, window) {
      var $, imgs, randocat;

      $ = window.$;
      imgs = [];
      $("a.preview-image > img").each(function() {
        return imgs.push($(this).attr("data-src"));
      });
      randocat = imgs[Math.floor(Math.random() * imgs.length)];
      if (typeof callback === "function") {
        return callback(randocat);
      }
    });
  };

  /*
  Module dependencies.
  */


  addUser = function(source, sourceUser) {
    var user;

    user = void 0;
    if (arguments.length === 1) {
      user = sourceUser = source;
      user.id = ++nextUserId;
      return usersById[nextUserId] = user;
    } else {
      user = usersById[++nextUserId] = {
        id: nextUserId
      };
      user[source] = sourceUser;
    }
    return user;
  };

  createGist = function(data) {
    return github.gists.create(data, function(e, res) {
      return console.log(res);
    });
  };

  express = require("express");

  routes = require("./routes");

  user = require("./routes/user");

  github = require("./routes/github");

  https = require("https");

  GitHubApi = require("github");

  everyauth = require("everyauth");

  conf = require("./conf");

  cat = require("./octodex");

  app = express();

  usersById = {};

  usersByGhId = {};

  nextUserId = 0;

  github = new GitHubApi({
    version: "3.0.0"
  });

  everyauth.everymodule.findUserById(function(id, callback) {
    return callback(null, usersById[id]);
  });

  everyauth.github.appId(conf.github.appId).appSecret(conf.github.appSecret).scope("gist").findOrCreateUser(function(sess, accessToken, accessTokenExtra, ghUser) {
    github.authenticate({
      type: "oauth",
      token: accessToken
    });
    return usersByGhId[ghUser.id] || (usersByGhId[ghUser.id] = addUser("github", ghUser));
  }).redirectPath("/");

  app.configure(function() {
    app.set("views", __dirname + "/views");
    app.set("view engine", "jade");
    app.use(express.bodyParser());
    app.use(express.cookieParser());
    app.use(express.session({
      secret: "secret"
    }));
    app.use(everyauth.middleware(app));
    app.use(express.methodOverride());
    app.use(app.router);
    return app.use(express["static"](__dirname + "/public"));
  });

  app.get("/", function(req, res) {
    return cat.octodex(function(randocat) {
      return res.render("index", {
        pageData: {
          cat: randocat
        }
      });
    });
  });

  app.post("/creategist", function(req, res) {
    return createGist(req.body);
  });

  app.listen(3030);

  console.log("Go to http://localhost:3030");

}).call(this);
