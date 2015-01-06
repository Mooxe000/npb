#!/usr/bin/env coffee
echo = console.log
{PWD} = process.env
_ = require 'lodash'

require 'shelljs/global'
require 'shelljs/make'

getConfObj = (require './lib/conf_obj').get
saveConfObj = (require './lib/conf_obj').save
sync_conf = require './lib/sync_conf'
commander =
  install: require './lib/command/install'

# read from config file
conf_obj = getConfObj()
# adjust data to target structure
conf_obj_map = sync_conf.get conf_obj

target.sync = ->
  # save as file
  saveConfObj conf_obj_map

target.clean = ->
  for path in [
    "#{PWD}/node_modules"
    "#{PWD}/bower_components"
  ]
    rm '-rf', path

target.install = ->
  target.sync()
  commander
  .install conf_obj.feb

target.reinstall = ->
  target.clean()
  target.install()

target.help = ->
  echo 'help'

target.all = ->
  target.help()
