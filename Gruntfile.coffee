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
        files: "public/scss/*"
        tasks: "stylesheets"

      javascript:
        files: ["src-client/coffee/*.coffee", "specs/client/*.coffee"]
        tasks: "coffeescript"

    compass:
      dist:
        files:
          "public/css/mq.css": "public/scss/mq.scss"

    coffee:
      options:
        sourceMap: true
      compile:
        files:
          "public/js/testAllTheThings.js": ["public/coffee/client.coffee"]
          
      client_specs:
        files: grunt.file.expandMapping(["specs/client/*.coffee"], "specs/client/js/", {
          rename: (destBase, destPath) ->
            destBase + destPath.replace(/\.coffee$/, ".js").replace(/specs\//, "")
        })
    
    concat:
      js:
        src: ["src-client/js/libs/*.js", "src-client/js/libs/cm-modes/**/*.js"]
        dest: "public/js/libs.js"
          
    uglify:
      dev:
        options:
          sourceMap: "public/js/source.map"
          sourceMapRoot: "http://localhost:3030/"
          sourceMappingURL: "/js/source.map"  
        files:
          "public/js/testAllTheThings.min.js": ["public/js/client.js"]
      prod:
        files:
          "public/js/testAllTheThings.min.js": ["public/js/client.js"]

    jasmine:
      client:
        src: "This is loaded via client/client_spec_runner.tmpl"
        options:
          template: "specs/client/client_spec_runner.tmpl"
          specs: "specs/client/js/client/*Spec.js"
          helpers: ["specs/client/js/*Helper.js", "specs/client/lib/*.js"]
          vendor: ["This is loaded via client/client_spec_runner.tmpl"]
        
    cafemocha:
      testThis:
        src: "specs/server/*.coffee"
        options:
          ui: "tdd"
          # require: [ "should" ]
          reporter: "nyan"
          # grep: "specs/server/*"
        
    exec:
      copyCoffee:
        command: "mkdir -p public/coffee; cp -R src-client/coffee/ public/coffee/"

    clean:
      stylesheets: "public/css/*"
      javascript: "public/js/*"
      
  grunt.loadNpmTasks "grunt-contrib-watch"
  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-contrib-compass"
  grunt.loadNpmTasks "grunt-contrib-clean"
  grunt.loadNpmTasks "grunt-contrib-concat"
  grunt.loadNpmTasks "grunt-contrib-uglify"
  grunt.loadNpmTasks "grunt-contrib-jasmine"
  grunt.loadNpmTasks "grunt-cafe-mocha"
  grunt.loadNpmTasks "grunt-exec"

  # Clean, compile and concatenate JS
  grunt.registerTask "coffeescript", [ "exec:copyCoffee", "coffee", "concat:js", "jasmine:client", "cafemocha" ]

  # Clean and compile stylesheets
  grunt.registerTask "stylesheets", [ "compass" ]

  # Default task
  grunt.registerTask "default", [ "coffeescript", "stylesheets" ]
