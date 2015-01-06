eyes = require 'eyes'
_ = require 'lodash'

module.exports = (conf_obj) ->
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

  deps = dependence.npm.dependencies
  if (
    _.isArray deps
  ) and !_.isEmpty deps
    for pkg in deps
      exec "npm install --save #{pkg}"

  deps = dependence.npm.devDependencies
  if (
    _.isArray deps
  ) and !_.isEmpty deps
    for pkg in deps
      exec "npm install --save-dev #{pkg}"

  deps = dependence.bower.dependencies
  if (
    _.isArray deps
  ) and !_.isEmpty deps
    for pkg in deps
      exec "bower install --save #{pkg}"

  deps = dependence.bower.devDependencies
  if (
    _.isArray deps
  ) and !_.isEmpty deps
    for pkg in deps
      exec "bower install --save-dev #{pkg}"

  exec 'npm prune'