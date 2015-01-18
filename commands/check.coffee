echo = console.log
error = console.error
_ = require 'lodash'
{exit} = process
{status} = require './libs/config'
check = require './libs/check'

module.exports = ->

  # check step 0: Uninitialized
  check.initialize()
  .then (cont, result_arr) ->
    step = 'Uninitialized'
    exists = _.pluck result_arr, 'exist'
    for index, exist of exists
      unless exist
        check_name = result_arr[index].name
        error "check error: \"#{check_name}\" #{step}"
        echo 'You can exec command `psb init` to init the project.'
        exit 1
  .fail (cont, error) ->
    exit 1
