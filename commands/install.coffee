echo = console.log
{error} = console
{exit} = process
_ = require 'lodash'
require 'shelljs/global'
{join} = require 'path'
del = require 'del'
{
  read_config_file
  group_config
} = require './libs/config'
{
  get_config
  get_wait_list
  count_install_pkgs
} = require './installHelper'

module.exports = ->
  # Prune extra pkgs
  exec 'bower prune'
  exec 'npm prune'

  # Config
  config = read_config_file()
  config = group_config config
  config = get_config config

  # Get wait install pkgs list
  wait_list = get_wait_list config
  count = count_install_pkgs wait_list.install

  if count > 0

    # Install
    for npm_or_bower in [
      'npm'
      'bower'
    ]
      for dep_or_devdep in [
        'dependencies'
        'devDependencies'
      ]
        commander = npm_or_bower
        save_option = do ->
          switch dep_or_devdep
            when 'dependencies' then return '--save'
            when 'devDependencies' then return '--save-dev'
        pkgnames = wait_list.install[npm_or_bower][dep_or_devdep]
        unless _.isEmpty pkgnames
          for index, pkgname of pkgnames
            echo ">> start install #{pkgname}.."
            exec "#{commander} install #{save_option} #{pkgname}"
            echo ">> #{pkgname} installed done."
            echo '' unless index is pkgnames.length

    # Recalculated pkgs list
    wait_list = get_wait_list config

  # Clean extra pkgs
  clean_list = []
  for npm_or_bower in [
    'npm'
    'bower'
  ]
    for pkgname in  wait_list.clean[npm_or_bower]
      clean_path = join config[npm_or_bower].dest, pkgname
      clean_list.push clean_path
  unless _.isEmpty clean_list
    del clean_list, (err, paths) ->
      unless err
        echo JSON.stringify paths, null, 2
      else
        error err
        exit 1

  # bower handle back
