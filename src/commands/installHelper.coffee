echo = console.log
{join} = require 'path'
{PWD} = process.env
{exit} = process
fs = require 'fs'
fse = require 'fs-extra'
del = require 'del'
{error} = console
_ = require 'lodash'
Thenjs = require 'thenjs'
{
  status
} = require '../libs/config'

step = 'Uninstalled'

get_config = (config) ->

  bower_keep_list = config.bower_deps.keep_list

  config =
    npm: config.npm_deps
    bower: config.bower_deps.deps_conf

  config.npm.dest = join PWD, status[step].npm_dir
  config.bower.dest = join PWD, status[step].bower_dir
  config.bower.keep_list = bower_keep_list

  config

get_installed_pkgnames = (config) ->
  dest =
    npm: config.npm.dest
    bower: config.bower.dest
  installed_pkgs = {}
  for name, path of dest
    installed_pkgs[name] =
      if fs.existsSync path
      then _.without (
        fse.readdirSync path
      ), '.bin'
      else []
  installed_pkgs

group_dep_devdep = (wait_list, dep_list, dev_dep_list) ->
  result =
    dependencies: []
    devDependencies: []

  for pkgname in wait_list
    index_dep = _.findIndex dep_list, (dep_pkg) ->
      dep_pkg is pkgname
    index_dev_dep = _.findIndex dev_dep_list, (dev_dep_pkg) ->
      dev_dep_pkg is pkgname
    if index_dep >= 0
      result.dependencies.push pkgname
      continue
    else if index_dev_dep >= 0
      result.devDependencies.push pkgname
      continue
    else continue

  result

get_wait_list = (config, installed_pkgs) ->
  deps =
    npm: []
    bower: []
  deps.npm = _.union deps.npm
  , config.npm.dependencies
  , config.npm.devDependencies
  deps.bower = _.union deps.bower
  , config.bower.dependencies
  , config.bower.devDependencies

  wait_list =
    npm: _.difference deps.npm, installed_pkgs.npm
    bower: _.difference deps.bower, installed_pkgs.bower

  install:
    npm: group_dep_devdep wait_list.npm
    , config.npm.dependencies
    , config.npm.devDependencies
    bower: group_dep_devdep wait_list.bower
    , config.bower.dependencies
    , config.bower.devDependencies
  clean:
    npm: _.difference installed_pkgs.npm, deps.npm
    bower: _.difference installed_pkgs.bower, deps.bower

count_install_pkgs = (wait_install_pkgs) ->
  count = 0
  for npm_or_bower in [
    'npm'
    'bower'
  ]
    for dep_or_devdep in [
      'dependencies'
      'devDependencies'
    ]
      count += wait_install_pkgs[npm_or_bower][dep_or_devdep].length
  count

cleanDir = (dir) ->
  return unless fs.statSync(dir).isDirectory()
  for file in fs.readdirSync dir
    fse.removeSync (
      join dir, file
    )

moveFiles = (filenames, src_dir, dest_dir) ->
  cleanDir dest_dir
  for filename in filenames
    src_file = join src_dir, filename
    dest_file = join dest_dir, filename
    fse.copySync src_file, dest_file

handle_back_bower = (keep_list) ->
  {
    dest
    keep_list
  } = keep_list

  # ensure tmp dir
  tmp_path = join PWD, '.tmp'
  fse.ensureDirSync tmp_path

  for pkgname, pkgfiles of keep_list
    # except keep all the files
    continue if pkgfiles is ''
    # single file to array
    pkgfiles = [pkgfiles] if _.isString pkgfiles
    pkg_parent_path = join dest, pkgname
    # move to tmp dir
    # TODO filter css/font/js and others
    moveFiles pkgfiles, pkg_parent_path, tmp_path
    # move back
    moveFiles pkgfiles, tmp_path, pkg_parent_path

  fse.removeSync tmp_path

exports.get_config = get_config
exports.get_wait_list = (config) ->
  installed_pkgs = get_installed_pkgnames config
  get_wait_list config, installed_pkgs
exports.count_install_pkgs = count_install_pkgs
exports.handle_back_bower = handle_back_bower
