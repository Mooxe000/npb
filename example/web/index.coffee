#!/usr/bin/env coffee
require 'shelljs/make'
eyes = require 'eyes'

target.install = ->
  exec '../../index.coffee install'

target.all = ->
  target.install()
