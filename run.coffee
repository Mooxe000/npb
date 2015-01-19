#!/usr/bin/env coffee
require 'shelljs/make'
echo = console.log

check = require './commands/check'
init = require './commands/init'
show = require './commands/show'

target.check = -> do check
target.init = -> do init
target.show = -> do show

target.all = ->
  echo 'hello'
