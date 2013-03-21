
/*
 * GET connect to github.
 */
var GitHubApi = require("github");

var github = new GitHubApi({
    // required
    version: "3.0.0",
    // optional
    timeout: 5000
});

exports.connect = function(req, res){
  github.user.getFollowingFromUser({
    user: "robtarr"
  }, function(err, res) {
    console.log(JSON.stringify(res));
  });
  res.send( "connecting...")
};