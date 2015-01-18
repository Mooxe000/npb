#!/usr/bin/env coffee
require 'shelljs/make'
echo = console.log

check = require './commands/check'
init = require './commands/init'

target.check = -> do check
target.init = -> do init

target.all = ->
  echo 'hello'
