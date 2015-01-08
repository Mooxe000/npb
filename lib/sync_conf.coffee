echo = console.log
eyes = require 'eyes'
_ = require 'lodash'

getSyncConf = (conf_obj) ->

  result =
    config: do ->
      return {} if _.isEmpty conf_obj.npb.npb
      config = _.cloneDeep conf_obj.npb.npb
      delete conf_obj.npb.npb
      config
    public: do ->
      return {} if _.isEmpty conf_obj.npb
      _.omit conf_obj.npb, (value, key) ->
        key is 'bower' or
        key is 'npm'

  funExceptDep = (value, key) ->
    key is 'dependencies' or
    key is 'devDependencies' or
    key is 'npb'

  for module in [
    'bower'
    'npm'
  ]
    result[module] =
      if (
        module is 'bower'
      ) and _.isEmpty conf_obj[module]
      then {}
      else
        # load conf file
        config: do ->
          return {} if _.isEmpty conf_obj[module]
          _.omit conf_obj[module], funExceptDep
        # load custom conf
        custom: do ->
          return {} if _.isEmpty conf_obj.npb
          return {} if _.isEmpty conf_obj.npb[module]
          _.omit conf_obj.npb[module], funExceptDep

  for module in [
    'bower'
    'npm'
  ]
    continue if _.isEmpty result[module]

    # merge public
    unless _.isEmpty result.public
      for key, value of result.public
        result[module].config[key] = value

    # merge custom
    unless _.isEmpty result[module].custom
      for key, value of result[module].custom
        result[module].config[key] = value

    result[module] = result[module].config

    # set packages empty
    result[module].dependencies = {}
    result[module].devDependencies = {}

  delete result.public

  result

module.exports.get = getSyncConf