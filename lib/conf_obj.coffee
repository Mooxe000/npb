eyes = require 'eyes'
_ = require 'lodash'
{PWD} = process.env
fs = require 'fs'
path = require 'path'
{extname} = path
jf = require 'jsonfile'
cson_parse = (require './simple_cson').parse

conf_file_path_map =
  npb: "#{PWD}/npb.cson"
  npm: "#{PWD}/package.json"
  bower: "#{PWD}/bower.json"

getConfObj = ->

  conf_obj_map = {}

  for key, value of conf_file_path_map
    _extname = extname value
    if _extname is '.cson'
      parse = cson_parse
    else if _extname is '.json'
      parse = jf.readFileSync
    else return

    conf_obj_map[key] =
      if fs.existsSync value
      then parse value
      else {}

  conf_obj_map

saveConfObj = (conf_obj_map) ->
  conf_file = {}
  for module in [
    'npm'
    'bower'
  ]
    unless _.isEmpty conf_obj_map[module]
      conf_file[module] =
        path: conf_file_path_map[module]
        obj: conf_obj_map[module]
      {
        path
        obj
      } = conf_file[module]
      jf.writeFileSync path, obj

module.exports.get = getConfObj
module.exports.save = saveConfObj
