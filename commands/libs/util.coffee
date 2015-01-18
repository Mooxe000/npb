_ = require 'lodash'

obj2arr = (obj) ->
  return unless _.isObject obj
  result = []
  for key, value of obj
    _obj_ = {}
    _obj_[key] = value
    result.push _obj_
  result

getUniqueKey = (obj) ->
  (
    _.keys obj
  )[0]

exports.obj2arr = obj2arr
exports.getUniqueKey = getUniqueKey