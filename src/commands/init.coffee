echo = console.log
error = console.error
_ = require 'lodash'
Thenjs =  require 'thenjs'
fse = require 'fs-extra'
{join} = require 'path'
{exit} = process
{PWD} = process.env
{status} = require '../libs/config'
check = require './checkHelper'

module.exports = ->

  check.initialize()
  .then (cont, result_arr) ->

    step = 'Uninitialized'
    check_conf = status[step]

    wait_list = _.pluck (
      _.filter result_arr, exist: false
    ), 'name'

    template_parent_path = join __dirname, '../../template'

    Thenjs.each wait_list
    , (contA, name) ->
      file_name = check_conf[name]
      template = join template_parent_path
      , file_name
      if file_name is '.gitignore'
        template = join template_parent_path
        , '.npmignore' unless fse.existsSync template
      dest = join PWD, file_name
      # Copy
      fse.copy template, dest
      , (err) ->
        unless err
          echo "init #{name} done."
        else
          error err

    .then -> cont null, true

  .fail (cont, err) ->
    error err
    exit 1
