echo = console.log
{error} = console
_ = require 'lodash'
Thenjs = require 'thenjs'
{
  status
  read_config_file
  group_config
} = require './libs/config'
{join} = require 'path'
{PWD} = process.env
{exit} = process
jf = require 'jsonfile'

module.exports = ->
  config = read_config_file()
  config = group_config config

  step = 'Unsynchronized'

  npm_conf_file_path = join PWD, status[step].npm
  bower_conf_file_path = join PWD, status[step].bower

  handle_arr = [
    (cont) ->
      jf.writeFile npm_conf_file_path, config.npm, cont
  ]

  unless (
    _.isEmpty config.bower.dependencies
  ) and (
    _.isEmpty config.bower.devDependencies
  )
    handle_arr.push (cont) ->
      jf.writeFile bower_conf_file_path, config.bower, cont

  Thenjs.parallel handle_arr
  .then (cont, result_arr) ->
    cont null, true
  .fail (cont, err) ->
    error err
    exit 1
