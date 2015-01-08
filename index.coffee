#!/usr/bin/env coffee
eyes = require 'eyes'
_ = require 'lodash'

require 'shelljs/make'

getConfObj  = (require './lib/conf_obj').get
saveConfObj = (require './lib/conf_obj').save
sync_conf = require './lib/sync_conf'
commander =
  init:     require './lib/command/init'
  clean:    require './lib/command/clean'
  install:  require './lib/command/install'

# read from config file
conf_obj      = getConfObj()

# adjust data to target structure
conf_obj_map  = sync_conf.get conf_obj

# npb config
npb_conf      = conf_obj_map.config

target.init   = -> commander.init()
target.clean  = -> commander.clean()

# save as file
target.sync   = -> saveConfObj conf_obj_map

target.install    = ->
  target.sync()
  commander.install conf_obj.npb
  , npb_conf

target.reinstall  = ->
  target.clean()
  target.install()

target.help   = ->
  echo 'help'

target.all    = ->
  target.help()
