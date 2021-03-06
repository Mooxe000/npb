echo = console.log
{error} = console
fs = require 'fs'
coffee = require 'coffee-script'
{exit} = process

parse = (cson_file_path) ->
  cson_file = (
    fs.readFileSync cson_file_path
  ).toString()

  json_str = coffee.compile cson_file, bare: true
  rows = (json_str.split '\n')[1..-3]
  for index, line of rows
    rows[index] = line
    .replace /\w+:/g, (match, offset, contents) ->
      return match if match is 'http:' or
        match is 'https:' or
        match is 'git:'
      "\"#{match.replace /:/g, ''}\":"
    .replace /\'/g, '\"'
  json_str = rows.join ''
  json_str = "{#{json_str}}"
  try
    json_obj = JSON.parse json_str
  catch e
    error "Error parse npb config cson, please check you 'npb.cson'."
    echo json_str
    exit 1
  json_obj

exports.parse = parse