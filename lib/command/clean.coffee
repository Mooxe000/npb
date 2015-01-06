echo = console.log
{PWD} = process.env
require 'shelljs/global'

module.exports = ->

  for path in [
    "#{PWD}/node_modules"
    "#{PWD}/bower_components"
  ]
    rm '-rf', path
