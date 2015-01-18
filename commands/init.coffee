echo = console.log
error = console.error
_ = require 'lodash'
Thenjs =  require 'thenjs'
fse = require 'fs-extra'
{join} = require 'path'
{exit} = process
{PWD} = process.env
{status} = require './libs/config'
check = require './libs/check'

module.exports = ->

  check.initialize()
  .then (cont, result_arr) ->

    step = 'Uninitialized'
    check_conf = status[step]

    wait_list = _.pluck (
      _.filter result_arr, exist: false
    ), 'name'

    Thenjs.each wait_list
    , (contA, name) ->
      file_name = check_conf[name]
      template = join (
        join __dirname, '../template'
      ), file_name
      dest = join PWD, file_name
      fse.copy template, dest
      , (err) ->
        unless err
          echo 'init' + name + ' done.'
        else
          error err

    .then -> cont null, true

  .fail (cont, err) ->
    error err
    exit 1
