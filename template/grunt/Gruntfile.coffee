echo = console.log
gruntutil = require './grunt/gruntutil'
loadNpmTasks = require './grunt/loadNpmTasks'
{loadTasks} = gruntutil
{invokeConfigFn} = gruntutil

module.exports = (grunt) ->
  global.shoudPrefix = false

  # Load task functions
  taskConfigurations = loadTasks './grunt/tasks'
  registerDefinitions = loadTasks './grunt/register'

  # (ensure that a default task exists)
  unless registerDefinitions.default
    registerDefinitions.default = (grunt) ->
      grunt.registerTask 'default', []

  # Run task functions to configure Grunt.
  invokeConfigFn taskConfigurations, grunt
  invokeConfigFn registerDefinitions, grunt

  # loadNpmTasks
  loadNpmTasks grunt
