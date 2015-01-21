#!/usr/bin/env coffee
require 'shelljs/global'
require 'shelljs/make'
echo = console.log

check = require '../src/commands/check'
init = require '../src/commands/init'
show = require '../src/commands/show'
sync = require '../src/commands/sync'
clean = require '../src/commands/clean'
install = require '../src/commands/install'
reinstall = require '../src/commands/reinstall'
{
  grunt
  gulp
} = require '../src/commands/buildtool'

target.check = -> do check
target.init = -> do init
target.show = -> do show
target.sync = -> do sync
target.clean = -> do clean
target.install = -> do install
target.reinstall = -> do reinstall
target.grunt = -> do grunt
target.gulp = -> do gulp

target.help   = ->
  echo '>> echo help info.'

target.all = -> do target.help