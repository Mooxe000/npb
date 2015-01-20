require 'shelljs/global'
{join} = require 'path'

module.exports = ->
  command = join __dirname, '../bin/npb.coffee'
  exec "#{command} clean"
  exec "#{command} install"
