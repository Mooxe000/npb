echo = console.log
fs = require 'fs'
path = require 'path'
{
  join
  basename
} = path

loadTasks = (relPath) ->
  tasks = {}
  files = fs.readdirSync relPath
  for file in files
    filepath = join "#{process.cwd()}/#{relPath}/#{file}"
    filename = basename filepath, '.coffee'
    tasks[filename] = require filepath
  tasks

invokeConfigFn = (tasks, grunt) ->
  for taskName of tasks
    tasks[taskName] grunt if tasks.hasOwnProperty taskName
  return

exports.loadTasks = loadTasks
exports.invokeConfigFn = invokeConfigFn
