#global module:false
module.exports = (grunt) ->

  # Project configuration.
  grunt.initConfig
    pkg: grunt.file.readJSON("package.json")

    watch:
      stylesheets:
        files: "public/scss/*"
        tasks: "stylesheets"

      javascript:
        files: ["public/coffee/*"]
        tasks: "javascript"

    compass:
      dist:
        files:
          "public/css/mq.css": "public/scss/mq.scss"

    coffee:
      compile:
        files:
          "public/js/client.js": "public/coffee/client.coffee"
          
    concat:
      js:
        src: ["public/js/libs/*.js", "public/js/libs/cm-modes/**/*.js", "public/js/client.js"]
        dest: "public/js/<%= pkg.name %>.js"          
          
    clean:
      stylesheets: "public/css/*"
      javascript: "public/js/*"
      
  grunt.loadNpmTasks "grunt-contrib-watch"
  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-contrib-compass"
  grunt.loadNpmTasks "grunt-contrib-clean"
  grunt.loadNpmTasks "grunt-contrib-concat"

  # Clean, compile and concatenate JS
  grunt.registerTask "javascript", [ "coffee", "concat:js" ]

  # Clean and compile stylesheets
  grunt.registerTask "stylesheets", [ "compass" ]

  # Default task
  grunt.registerTask "default", [ "javascript", "stylesheets" ]
