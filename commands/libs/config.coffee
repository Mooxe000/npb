module.exports =

  status:

    # npb.cson not exist
    Uninitialized:
      npb: 'npb.cson'
      gitignore: '.gitignore'
      readme: 'README.md'

    # bower.json or package.json not exist
    Unsynchronized:
      npm: 'package.json'
      bower: 'bower.json'

    # bower_components or node_modules not exist
    Uninstalled:
      npm_dir: 'node_modules'
      bower_dir: 'bower_components'
