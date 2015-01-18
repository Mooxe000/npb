eyes = require 'eyes'
_ = require 'lodash'
walkSync = require 'walk-sync'
fs = require 'fs-extra'
{PWD} = process.env
{
  join
  basename
  extname
} = require 'path'

module.exports = (conf_obj, npb_conf) ->
  {
    config
    bower
    npm
  } = conf_obj

  dependence =
    bower:
      dependencies: bower.dependencies
      devDependencies: bower.devDependencies
    npm:
      dependencies: npm.dependencies
      devDependencies: npm.devDependencies

  checkDeps = (deps) ->
    if  (
      ( _.isArray deps ) and !_.isEmpty deps
    ) or (
      ( _.isObject deps ) and !_.isEmpty _.keys deps
    )
      true
    else false

  getDeps = (deps) ->
    if _.isPlainObject deps
      _.keys deps
    else deps

  # NPM
  deps = dependence.npm.dependencies
  if checkDeps deps
    for pkg in getDeps deps
      exec "#{npb_conf.commander or 'npm'} install --save #{pkg}"

  deps = dependence.npm.devDependencies
  if checkDeps deps
    for pkg in getDeps deps
      exec "#{npb_conf.commander or 'npm'} install --save-dev #{pkg}"

  # BOWER
  deps = dependence.bower.dependencies
  if checkDeps deps
    for pkg in getDeps deps
      if npb_conf.bower?.root_allow?
        exec "bower install --allow-root --save #{pkg}"
      else
        exec "bower install --save #{pkg}"

  deps = dependence.bower.devDependencies
  if checkDeps deps
    for pkg in getDeps deps
      if npb_conf.bower?.root_allow?
        exec "bower install --allow-root --save-dev #{pkg}"
      else
        exec "bower install --save-dev #{pkg}"

  # CLEAN
  exec 'bower prune'
  exec 'npm prune'

  getLibs = (deps) ->
    libs = {}
    for depObj in deps
      continue unless _.isObject depObj
      _.merge libs, depObj
    libs

  except = (array, except_arr) ->
    result = array
    for obj in except_arr
      result = _.without result, obj
    result

  removeAll = (dir) ->
    return unless fs.statSync(dir).isDirectory()
    for file in fs.readdirSync dir
      fs.removeSync (
        join dir, file
      )

  handleBowerBack = ->
    return unless npb_conf.bower?.base?
    base = join PWD, npb_conf.bower.base

    libs = getLibs [
      dependence.bower.dependencies
      dependence.bower.devDependencies
    ]

    # clean except
    without = except (
      fs.readdirSync base
    ), (
      _.keys libs
    )
    for clean_dir in without
      fs.removeSync join base, clean_dir
    # ------------

    tmp_path = join PWD, '.tmp'
    fs.mkdirpSync tmp_path

    for lib_name in _.keys libs
      continue if libs[lib_name] is ''
      lib_path = join base, lib_name
      # move to tmp dir
      removeAll tmp_path
      if _.isArray libs[lib_name]
        for file in libs[lib_name]
          file = join (
            join base, lib_name
          ), file
          fs.copySync file, (
            join tmp_path, basename file
          )
      if _.isString libs[lib_name]
        file = libs[lib_name]
        fs.copySync file, (
          join tmp_path, basename file
        )
      # move back to bower dir
      removeAll lib_path
      if _.isArray libs[lib_name]
        for file in libs[lib_name]
          fs.copySync (
            join tmp_path, basename file
          ), (
            join lib_path, basename file
          )
      if _.isString libs[lib_name]
        file = libs[lib_name]
        fs.copySync (
          join tmp_path, basename file
        ), (
          join lib_path, basename file
        )
    fs.removeSync tmp_path

  handleBowerBack()

