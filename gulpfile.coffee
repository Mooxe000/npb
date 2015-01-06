echo = console.log
gulp = require 'gulp'
{
  loadTasks
  invokeConfigFn
} = require './gulp/gulputil'

# Load task functions
taskConfigurations = loadTasks './gulp/tasks'
registerDefinitions = loadTasks './gulp/register'

# (ensure that a default task exists)
unless registerDefinitions.default
  registerDefinitions.default = ->
    gulp.task 'default', ->
      echo 'default task here'

# Run task functions to configure Grunt.
invokeConfigFn taskConfigurations, gulp
invokeConfigFn registerDefinitions, gulp