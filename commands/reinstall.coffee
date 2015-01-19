require 'shelljs/global'
{join} = require 'path'

module.exports = ->
  command = join __dirname, '../run.coffee'
  exec "#{command} clean"
  exec "#{command} install"
