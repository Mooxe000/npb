echo = console.log
fs = require 'fs'
{
  join
  basename
  extname
} = require 'path'
PWD = process.cwd()

loadTasks = (relPath) ->
  tasks = {}
  files = fs.readdirSync relPath
  for file in files
    ext_name = extname file
    if ext_name is '.coffee'
      filepath = join "#{PWD}/#{relPath}/#{file}"
      filename = basename filepath, ext_name
      tasks[filename] = require filepath
  tasks

exports.loadTasks = loadTasks