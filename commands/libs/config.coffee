echo = console.log
{error} = console
_ = require 'lodash'
fs = require 'fs'
jf = require 'jsonfile'
{PWD} = process.env
{exit} = process
{
  join
  extname
} = require 'path'
cson_parse = (
  require './simple_cson'
).parse

status =
  # npb.cson not exist
  Uninitialized:
    npb: 'npb.cson'
    gitignore: '.gitignore'
    readme: 'README.md'

  # bower.json or package.json not exist
  Unsynchronized:
    npm: 'package.json'
    bower: 'bower.json'

  # bower_components or node_modules not exist
  Uninstalled:
    npm_dir: 'node_modules'
    bower_dir: 'bower_components'

# read from config file
read_config_file = ->
  # TODO supper cson.json or not
  npb_conf = status.Uninitialized.npb
  file_path = join PWD, npb_conf
  cson_parse file_path

# group config
get_npb_config = (config) ->
  if !config.npb or _.isEmpty config.npb
  then {}
  else config.npb

get_public_config = (config) ->
  _.omit config, (value, key) ->
    key is 'npb' or
    key is 'npm' or
    key is 'bower'

get_bower_deps = (config) ->
  deps_conf:
    dependencies: _.keys config.bower.dependencies
    devDependencies: _.keys config.bower.devDependencies
  keep_list: _.assign config.bower.dependencies, config.bower.devDependencies

array_filter_string_object = (array, callback) ->
  return unless _.isArray array
  cb_array = []
  cb_object = {}
  for ele in array
    if _.isString ele
      cb_array.push ele
    else if _.isObject ele
      for key, value of ele
        cb_object[key] = value
    else return
  callback cb_array, cb_object

get_npm_deps = (config) ->
  dependencies: do ->
    result = []
    {dependencies} = config.npm
    return [] if _.isEmpty dependencies
    for pkg_name in config.npm.dependencies
      continue unless _.isString pkg_name
      result.push pkg_name
    result
  devDependencies: do ->
    {devDependencies} = config.npm
    return [] if _.isEmpty devDependencies
    array_filter_string_object devDependencies
    , (array, object) ->
      gulp_list = []
      grunt_list = []
      if object.gulp?
        gulp_list = array_filter_string_object object.gulp
        , (arrayA, objectA) -> arrayA
      if object.grunt?
        grunt_list = array_filter_string_object object.grunt
        , (arrayB, objectB) -> arrayB
      _.union array, gulp_list, grunt_list

get_grunt_tasks = (config) ->
  return [] unless config.npm?.devDependencies?
  return [] unless _.isArray config.npm.devDependencies
  return [] if _.isEmpty config.npm.devDependencies
  grunt_tasks = []
  _.findIndex config.npm.devDependencies
  , (ele) ->
    unless ele.grunt
      false
    else
      grunt_tasks = ele.grunt
      true
  grunt_tasks

deps_arr_to_obj = (deps) ->
  return {} unless _.isArray deps
  return {} if _.isEmpty deps
  result = {}
  for pkg_name in deps
    result[pkg_name] = '*'
  result

get_conf_tmp = (config) ->
  _.omit config, (value, key) ->
    key is 'dependencies' or
    key is 'devDependencies'

get_deps_tmp = (npm_or_bower) ->
  ependencies:
    if npm_or_bower.dependencies
    then deps_arr_to_obj npm_or_bower.dependencies
    else {}
  devDependencies:
    if npm_or_bower.devDependencies
    then deps_arr_to_obj npm_or_bower.devDependencies
    else {}

group_config = (config) ->
  npb_config = get_npb_config config
  public_config = get_public_config config
  bower_deps = get_bower_deps config
  npm_deps = get_npm_deps config
  grunt_tasks = get_grunt_tasks config

  npm_config = do ->
    result = {}
    npm_conf_tmp = get_conf_tmp config.npm
    npm_deps_tmp = get_deps_tmp npm_deps
    _.assign result, public_config, npm_conf_tmp, npm_deps_tmp
    result

  bower_config = do ->
    result = {}
    bower_conf_tmp = get_conf_tmp config.bower
    bower_deps_tmp = get_deps_tmp bower_deps.deps_conf
    _.assign result, public_config, bower_conf_tmp, bower_deps_tmp
    result

  npm: npm_config
  bower: bower_config
  npb: npb_config
  grunt: grunt_tasks

exports.status = status
exports.read_config_file = read_config_file
exports.group_config = group_config
