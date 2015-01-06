eyes = require 'eyes'
fs = require 'fs'
coffee = require 'coffee-script'

parse = (cson_file_path) ->
  cson_file = (
    fs.readFileSync './npb.cson'
  ).toString()

  json_str = coffee.compile cson_file, bare: true
  rows = (json_str.split '\n')[1..-3]
  for index, line of rows
    rows[index] = line
    .replace /\w+:/g, (match, offset, contents) ->
      return match if match is 'http:' or match is 'https:'
      "\"#{match.replace /:/g, ''}\":"
    .replace /\'/g, '\"'
  json_str = rows.join ''
  json_str = "{#{json_str}}"
  json_obj = JSON.parse json_str
  json_obj

exports.parse = parse