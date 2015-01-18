echo = console.log
_ = require 'lodash'
util = require './util'
Thenjs = require 'thenjs'
fs = require 'fs'
{PWD} = process.env
{join} = require 'path'
{status} = require './config'

# check step 0: Uninitialized
initialize_check = ->
  step = 'Uninitialized'
  check_conf = status[step]
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

# check step 1: Unsynchronized
synchronize_check = ->

# check step 2: Uninstalled
install_check = ->

module.exports =
  initialize: initialize_check
  synchronize: synchronize_check
  install: install_check
