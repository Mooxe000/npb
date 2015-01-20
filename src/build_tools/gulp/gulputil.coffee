echo = console.log
fs = require 'fs'
path = require 'path'
{
  join
  basename
  extname
} = path

loadTasks = (relPath) ->
  tasks = {}
  files = fs.readdirSync relPath
  for file in files
    ext_name = extname file
    if ext_name is '.coffee'
      filepath = join "#{process.cwd()}/#{relPath}/#{file}"
      filename = basename filepath, '.coffee'
      tasks[filename] = require filepath
  tasks

invokeConfigFn = (tasks, gulp) ->
  for taskName of tasks
    gulp.task taskName, tasks[taskName] if tasks.hasOwnProperty taskName

exports.loadTasks = loadTasks
exports.invokeConfigFn = invokeConfigFn