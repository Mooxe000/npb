{
  status
  read_config_file
  group_config
} = require './libs/config'
{join} = require 'path'


module.exports = ->
  # TODO check step
  # npm
  # bower
  # npb
  # grunt
  config = read_config_file()
  config = group_config config
  echo JSON.stringify config, null, 2
