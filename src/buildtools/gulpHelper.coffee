echo = console.log
_ = require 'lodash'

invokeConfigFn = (
  register_tasks
  task_tasks
  gulp
) ->
  tasks = _.assign register_tasks, task_tasks
  for taskName of tasks
    continue unless tasks.hasOwnProperty taskName
    gulp.task taskName, tasks[taskName]
  return

exports.invokeConfigFn = invokeConfigFn