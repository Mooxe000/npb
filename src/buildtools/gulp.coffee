echo = console.log
{loadTasks} = require './Helper'
{invokeConfigFn} = require './gulpHelper'

module.exports = (gulp) ->
  global.shoudPrefix = false

  # check $cwd/package.json

  # Load task functions
  taskConfigurations = loadTasks './gulp/tasks'
  registerDefinitions = loadTasks './gulp/register'

  # (ensure that a default task exists)
  unless registerDefinitions.default
    registerDefinitions.default = ->
      gulp.task 'default', ->
        echo 'default task here'

  # Run task functions to configure gulp.
  invokeConfigFn registerDefinitions, taskConfigurations, gulp