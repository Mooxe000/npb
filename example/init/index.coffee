#!/usr/bin/env coffee
require 'shelljs/make'
require 'shelljs/global'
walkSync = require 'walk-sync'
eyes = require 'eyes'

target.clean = ->
  files = walkSync './'
  for filename in files
    continue if filename is 'index.coffee'
    rm '-rf', filename

target.init = ->
  exec '../../index.coffee init'

target.all = ->
  target.clean()
  target.init()
