echo = console.log
_ = require 'lodash'

getSyncConf = (conf_obj) ->
  isNull =
    npm:
      if _.isEmpty conf_obj.npm
      then true
      else false
    bower:
      if _.isEmpty conf_obj.bower
      then true
      else false

  result =
    config: do ->
      return {} if _.isEmpty conf_obj.feb.config
      config = _.cloneDeep conf_obj.feb.config
      delete conf_obj.feb.config
      config
    public: do ->
      return {} if _.isEmpty conf_obj.feb
      _.omit conf_obj.feb, (value, key) ->
        key is 'bower' or
          key is 'npm'

  funExceptDep = (value, key) ->
    key is 'dependencies' or
      key is 'devDependencies'

  for module in [
    'bower'
    'npm'
  ]
    result[module] =
      if isNull[module]
      then {}
      else
        # load conf file
        config: do ->
          return {} if _.isEmpty conf_obj[module]
          _.omit conf_obj[module], funExceptDep
        # load custom conf
        custom: do ->
          return {} if _.isEmpty conf_obj.feb
          return {} if _.isEmpty conf_obj.feb[module]
          _.omit conf_obj.feb[module], funExceptDep

    unless _.isEmpty result[module]
      # merge public
      unless _.isEmpty result.public
        for key, value of result.public
          result[module].config[key] = value

      # merge custom
      unless _.isEmpty result.custom
        for key, value of result.custom
          result[module].config[key] = value

      # set packages empty
      result[module].config.dependencies = {}
      result[module].config.devDependencies = {}

    result[module] =
      if result[module].config
      then result[module].config
      else {}

  delete result.public

  result

module.exports.get = getSyncConf