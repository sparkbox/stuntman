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
          "public/js/testAllTheThings.js": ["src-client/coffee/client.coffee", "src-client/coffee/socketClient.coffee", "src-client/coffee/socketPerson.coffee"]
          "specs/server/src/app.js": ["conf.coffee", "octodex.coffee", "app.coffee"]
          
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

    
    jasmine_node:
      # matchall: true
      projectRoot: "./specs/server/"
      requirejs: true
      forceExit: true
      jUnit:
        report: false
        savePath : "./build/reports/jasmine/"
        useDotNotation: true
        consolidate: true
        
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
  grunt.loadNpmTasks "grunt-jasmine-node"
  grunt.loadNpmTasks "grunt-exec"

  # Clean, compile and concatenate JS
  grunt.registerTask "coffeescript", [ "exec:copyCoffee", "coffee", "concat:js", "jasmine:client" ] # "jasmine_node"

  # Clean and compile stylesheets
  grunt.registerTask "stylesheets", [ "compass" ]

  # Default task
  grunt.registerTask "default", [ "coffeescript", "stylesheets" ]
