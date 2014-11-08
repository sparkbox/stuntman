jasmineRequire.stuntman = function(j$) {
  j$.StuntmanReporter = jasmineRequire.StuntmanReporter(j$);
};

jasmineRequire.StuntmanReporter = function(j$) {

  var noopTimer = {
    start: function(){},
    elapsed: function(){ return 0; }
  };

  function StuntmanReporter(options) {
    var env = options.env || {},
        timer = options.timer || noopTimer;
        results = {
          specCount: 0,
          failureCount: 0,
          pendingCount: 0,
          failedSpecs: []
        };

    this.jasmineStarted = function() {
      timer.start();
    };

    this.jasmineDone = function() {
      for (var i = 0; i < results.failedSpecs.length; i++) {
        specFailureDetails(results.failedSpecs[i]);
      }

      var seconds = timer.elapsed() / 1000;

      window.jasmineResults = results;
      console.log(results);
    };

    this.specDone = function(result) {
      results.specCount++;

      if (result.status == "pending") {
        results.pendingCount++;
        return;
      }

      if (result.status == "passed") {
        return;
      }

      if (result.status == "failed") {
        results.failureCount++;
        results.failedSpecs.push(result);
      }
    };

    return this;

    function specFailureDetails(result) {
      for (var i = 0; i < result.failedExpectations.length; i++) {
        var failedExpectation = result.failedExpectations[i];
      }
    }
  }

  return StuntmanReporter;
};