#!/usr/bin/env coffee
require 'shelljs/global'
require 'shelljs/make'
echo = console.log

check = require '../commands/check'
init = require '../commands/init'
show = require '../commands/show'
sync = require '../commands/sync'
clean = require '../commands/clean'
install = require '../commands/install'
reinstall = require '../commands/reinstall'

target.check = -> do check
target.init = -> do init
target.show = -> do show
target.sync = -> do sync
target.clean = -> do clean
target.install = -> do install
target.reinstall = -> do reinstall

target.help   = ->
  echo '>> echo help info.'

target.all = -> do target.help