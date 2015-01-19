{
  read_config_file
  group_config
} = require './libs/config'

module.exports = ->
  # TODO check step
  # npm
  # bower
  # npb
  # grunt
  config = read_config_file()
  config = group_config config
  echo JSON.stringify config, null, 2
