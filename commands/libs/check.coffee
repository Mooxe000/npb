echo = console.log
{error} = console
_ = require 'lodash'
util = require './util'
Thenjs = require 'thenjs'
fs = require 'fs'
{PWD} = process.env
{join} = require 'path'
{status} = require './config'

check_files = (step, check_conf) ->
  check_list = util.obj2arr check_conf if _.isObject check_conf
  Thenjs.each check_list
  , (cont, check_obj) ->
    check_name = util.getUniqueKey check_obj
    file_name = check_obj[check_name]
    path = join PWD, file_name
    fs.exists path
    , (exists) ->
      cont null
      ,
        name: check_name
        exist: exists

error_handler = (step, result_arr) ->
  Thenjs.each result_arr
  , (cont, check) ->
    check_name = check.name
    {exist} = check
    unless exist
      error "check error: \"#{check_name}\" #{step}"
      switch step
        when 'Uninitialized'
          echo 'You can exec command `psb init` to init the project.'
        when 'Unsynchronized'
          echo 'You can exec command `psb sync` or `psb syncwp` to sync the config.'
        when 'Uninstalled'
          echo 'You can exec command `psb install` to install all the packages.'
        else
          error "step error: not exist step named #{step}"
      exit 1
    else
      cont null, check

# check step 0: Uninitialized
initialize_check = ->
  step = 'Uninitialized'
  check_files step, status[step]

# check step 1: Unsynchronized
synchronize_check = ->
  step = 'Unsynchronized'
  check_files step, status[step]

# check step 2: Uninstalled
install_check = ->
  step = 'Uninstalled'
  check_files step, status[step]

module.exports =
  initialize: initialize_check
  synchronize: synchronize_check
  install: install_check
  error_handler: error_handler
