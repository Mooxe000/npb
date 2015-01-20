echo = console.log
_ = require 'lodash'
{
  read_config_file
  group_config
} = require '../libs/config'

invokeConfigFn = (
  register_tasks
  task_tasks
  grunt
) ->
  tasks = task_tasks
  for taskName of tasks
    continue unless tasks.hasOwnProperty taskName
    grunt.config.set taskName
    , tasks[taskName]

  tasks = register_tasks
  for taskName of tasks
    continue unless tasks.hasOwnProperty taskName
    grunt.registerTask taskName
    , tasks[taskName]

  return

loadNpmTasks = (grunt) ->
  # Config
  config = read_config_file()
  config = group_config config
  for npmTask in config.grunt
    grunt.loadNpmTasks npmTask
  return

exports.invokeConfigFn = invokeConfigFn
exports.loadNpmTasks = loadNpmTasks
