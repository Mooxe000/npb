echo = console.log
{error} = console
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

  Thenjs.parallel [
    (cont) ->
      jf.writeFile npm_conf_file_path, config.npm, cont
    (cont) ->
      jf.writeFile bower_conf_file_path, config.bower, cont
  ]
  .then (cont, result_arr) ->
    cont null, true
  .fail (cont, err) ->
    error err
    exit 1
