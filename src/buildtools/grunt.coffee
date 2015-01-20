echo = console.log
{loadTasks} = require './Helper'
{
  invokeConfigFn
  loadNpmTasks
} = require './gruntHelper'

module.exports = (grunt) ->
  global.shoudPrefix = false

  # check $cwd/package.json

  # Load task functions
  taskConfigurations = loadTasks './gulp/tasks'
  registerDefinitions = loadTasks './gulp/register'

  # (ensure that a default task exists)
  unless registerDefinitions.default
    registerDefinitions.default = (grunt) ->
      grunt.registerTask 'default', []

  # Run task functions to configure Grunt.
  invokeConfigFn registerDefinitions
  , taskConfigurations, grunt

  # loadNpmTasks
  loadNpmTasks grunt