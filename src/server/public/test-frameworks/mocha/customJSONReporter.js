// module.exports = CustomJSONReporter;

function CustomJSONReporter(runner) {
  var self = this;
  Base.call(this, runner);

  var tests = []
    , failures = []
    , passes = [];

  // runner.on('test end', function(test){
  //   tests.push(test);
  // });

  runner.on('pass', function(test){
    passes.push(test);
  });

  runner.on('fail', function(test){
    failures.push(test);
  });

  runner.on('end', function(){
    var obj = {
        stats: self.stats
      , tests: tests.map(clean)
      , failures: failures.map(clean)
      , passes: passes.map(clean)
    };
    debugger;
    localStorage[ "results" ] = JSON.stringify(obj, null, 2);
  });
}