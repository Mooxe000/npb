# require './buildtoolHelper'
echo = console.log
{error} = console
fse = require 'fs-extra'
PWD = process.cwd()
{join} = require 'path'

config =
  grunt:
    Gruntfile:
      src: '../../template/buildtools/Gruntfile.coffee'
      dest: './Gruntfile.coffee'
    default:
      src: '../../template/buildtools/default.coffee'
      dest: './grunt/register/default.coffee'
    tasks:
      src: ''
      dest: './grunt/tasks/.gitkeep'
  gulp:
    gulpfile:
      src: '../../template/buildtools/gulpfile.coffee'
      dest: './gulpfile.coffee'
    default:
      src: '../../template/buildtools/default.coffee'
      dest: './gulp/register/default.coffee'
    tasks:
      src: ''
      dest: './gulp/tasks/.gitkeep'

ensure = (config)->
  for ele, conf of config
    src = join __dirname, conf.src unless conf.src is ''
    dest = join PWD, conf.dest
    unless fse.existsSync dest
      unless conf.src is ''
        fse.copySync src, dest
      else
        fse.createFileSync dest, ''
      echo "File '#{dest}' has bean created."
    else
      error "File '#{dest}' has been exist already."

exports.grunt = -> ensure config.grunt
exports.gulp = -> ensure config.gulp
