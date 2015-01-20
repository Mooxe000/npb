require 'shelljs/global'
{join} = require 'path'

module.exports = ->
  command = join __dirname, '../../bin/npb.coffee'
  exec "#{command} sync"
  exec "#{command} clean"
  exec "#{command} install"
