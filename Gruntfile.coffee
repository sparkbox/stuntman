#global module:false
module.exports = (grunt) ->

  # Project configuration.
  grunt.initConfig
    pkg: grunt.file.readJSON("package.json")

    watch:
      grunt:
        files: ["Gruntfile.coffee", "package.json"]
        tasks: "default"
      
      stylesheets:
        files: "src/client/scss/*.*"
        tasks: "stylesheets"

      javascript:
        files: ["src/client/coffee/*.coffee", "specs/*.coffee"]
        tasks: "coffeescript"

    compass:
      dist:
        files:
          "mq.css": "/src/client/scss/mq.scss"
          "no-mq.css": "/src/client/scss/no-mq.scss"

    coffee:
      options:
        sourceMap: true
      compile:
        files:
          "src/server/public/js/testAllTheThings.js": ["src/client/coffee/client.coffee", "src/client/coffee/socketClient.coffee", "src/client/coffee/socketPerson.coffee"]
      client_specs:
        files: grunt.file.expandMapping(["specs/client/*.coffee"], "specs/client/js/", {
          rename: (destBase, destPath) ->
            destBase + destPath.replace(/\.coffee$/, ".js").replace(/specs\//, "")
        })

    concat:
      js:
        src: ["src/client/js/libs/*.js", "src/client/js/libs/cm-modes/**/*.js"]
        dest: "src/server/public/js/libs.js"
          
    uglify:
      dev:
        options:
          sourceMap: "src/server/public/js/source.map"
          sourceMapRoot: "http://localhost:3030/"
          sourceMappingURL: "/js/source.map"
        files:
          "src/server/public/js/testAllTheThings.min.js": ["src/server/public/js/client.js"]
      prod:
        files:
          "src/server/public/js/testAllTheThings.min.js": ["src/server/public/js/client.js"]

    jasmine:
      src: "This is loaded via client/client_spec_runner.tmpl"
      options:
        template: "specs/client/client_spec_runner.tmpl"
        specs: "specs/client/js/client/*Spec.js"
        helpers: ["specs/client/js/*Helper.js", "specs/client/lib/*.js"]
        vendor: ["This is loaded via client/client_spec_runner.tmpl"]

    mochacli:
      options:
        reporter: 'nyan'
        bail: true
        compilers: ['coffee:coffee-script']
        ui: "tdd"
      all: ["specs/server/*Spec.coffee"]

    exec:
      copyCoffee:
        command: "mkdir -p public/coffee; cp -R src/client/coffee/ public/coffee/"

    clean:
      stylesheets: "src/server/public/css/*"
      javascript: "src/server/public/js/*"
      sourcemaps: ["src/server/public/scss", "src/server/public/coffee", "src/server/public/js/testAllTheThings.map"]
      
  grunt.loadNpmTasks "grunt-contrib-watch"
  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-contrib-compass"
  grunt.loadNpmTasks "grunt-contrib-clean"
  grunt.loadNpmTasks "grunt-contrib-concat"
  grunt.loadNpmTasks "grunt-contrib-uglify"
  grunt.loadNpmTasks "grunt-contrib-jasmine"
  grunt.loadNpmTasks "grunt-exec"
  grunt.loadNpmTasks "grunt-mocha-cli"

  # Clean, compile and concatenate JS
  grunt.registerTask "coffeescript", [ "exec:copyCoffee", "coffee", "concat:js", "mochacli", "jasmine" ]
  grunt.registerTask 'test', ['mochacli']
  
  # Clean and compile stylesheets
  grunt.registerTask "stylesheets", [ "compass" ]

  # Production build
  grunt.registerTask "production", [ "default", "clean:sourcemaps" ]
  
  # Default task
  grunt.registerTask "default", [ "coffeescript", "stylesheets" ]
