#!/usr/bin/env coffee
require 'shelljs/make'
echo = console.log

check = require './commands/check'
init = require './commands/init'
show = require './commands/show'
sync = require './commands/sync'
clean = require './commands/clean'

target.check = -> do check
target.init = -> do init
target.show = -> do show
target.sync = -> do sync
target.clean = -> do clean

target.all = ->
  echo 'hello'
