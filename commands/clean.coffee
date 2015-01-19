echo = console.log
{error} = console
{exit} = process
{PWD} = process.env
{join} = require 'path'
fs = require 'fs'
Thenjs = require 'thenjs'
del = require 'del'
{status} = require './libs/config'

module.exports = ->
  step = 'Uninstalled'
  npm_dir = join PWD, status[step].npm_dir
  bower_dir = join PWD, status[step].bower_dir

  Thenjs.each [
    npm_dir
    bower_dir
  ], (cont, del_path) ->

    fs.exists del_path, (exists) ->

      unless exists
        cont null, true
      else
        del [del_path], (err, paths) ->
          unless err
            echo JSON.stringify paths, null, 2
            cont null, true
          else
            cont err

  .fail (cont, err) ->
    error err
    exit 1
