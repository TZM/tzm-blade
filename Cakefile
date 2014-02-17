fs            = require 'fs'
wrench        = require 'wrench'
{print}       = require 'util'
which         = require 'which'
{spawn, exec} = require 'child_process'

# ANSI Terminal Colors
bold  = '\x1B[0;1m'
red   = '\x1B[0;31m'
green = '\x1B[0;32m'
reset = '\x1B[0m'

pkg = JSON.parse fs.readFileSync('./package.json')
testCmd = pkg.scripts.test
startCmd = pkg.scripts.start

log = (message, color, explanation) ->
  console.log color + message + reset + ' ' + (explanation or '')

# Compiles app.coffee and src directory to the .app directory
build = (callback) ->
  # options = ['-c','-b', '-o', '.app', 'src']
  # cmd = which.sync 'coffee'
  # coffee = spawn cmd, options
  # coffee.stdout.pipe process.stdout
  # coffee.stderr.pipe process.stderr
  # coffee.on 'exit', (status) -> callback?() if status is 0
  exec 'npm shrinkwrap'
  callback?()

# mocha test
test = (callback) ->
  process.env["NODE_ENV"] = "test"
  options = [
    '--globals'
    'hasCert,res'
    '--reporter'
    'spec'
    '--compilers'
    'coffee:coffee-script'
    '--colors'
    '--require'
    'should'
    '--require'
    './run'
  ]
  try
    cmd = which.sync 'mocha'
    spec = spawn cmd, options
    spec.stdout.pipe process.stdout 
    spec.stderr.pipe process.stderr
    spec.on 'exit', (status) -> callback?() if status is 0
  catch err
    log err.message, red
    log 'Mocha is not installed - try npm install mocha -g', red

task 'coffeelint', 'check code style with coffeelint', ->
  try
    cmd ='./node_modules/coffeelint/bin/coffeelint'
    options = ['-f', 'test/lint.json', '-r', 'app']
    coffeelint = spawn cmd, options
    coffeelint.stdout.pipe process.stdout
    coffeelint.stderr.pipe process.stderr
    coffeelint.on 'exit', (status) -> callback?() if status is 0
  catch err
    log err.message, red
    log 'Coffeelint is not installed - try npm install coffeelint -g', red

task 'apidoc', 'generate API documentation', ->
  exec "./node_modules/coffeedoc/bin/coffeedoc -o docs html src"
  
task 'docs', 'Generate annotated source code with Doccco-Husky', ->
  files = wrench.readdirSyncRecursive("src")
  files = ("src/#{file}" for file in files when /\.coffee$/.test file)
  log files
  try
    cmd ='./node_modules/.bin/docco-husky' 
    docco = spawn cmd, files
    docco.stdout.pipe process.stdout
    docco.stderr.pipe process.stderr
    docco.on 'exit', (status) -> callback?() if status is 0
  catch err
    log err.message, red
    log 'Docco is not installed - try npm install docco -g', red

task 'build', ->
  build -> log "✓ Build complete, now run `cake dev`", green

task 'spec', 'Run Mocha tests', ->
  build -> test -> log "✓ Mocha spec complete", green

task 'test', 'Run Mocha tests', ->
  build -> test -> log "✓ Mocha tests complete", green

option '-v', '--version', "show app's version number"

option '-e', '--email [EMAIL]', "add an admin email address for `cake setup`"
option '-w', '--password [PASSWORD]', 'set the password for the specified email address'
task 'setup', 'Create a new administrator account', (options) ->
  email = options.email
  pass = options.password

  console.log 'setup', email

  if pass and pass.length < 6
    return console.log 'Password must be at least 6 characters long'

  dbconnect = require './app/utils/dbconnect'
  dbconnect.init (err) ->
    return console.log 'setup error', err if err
    User = require './app/models/user/user'

    User.findOne {email:email}, (err, user) ->
      console.log 'failed', err if err
      return setupFinish err if err

      if user
        console.log 'user exists', user.email, user.groups
        return setupFinish if user.groups is 'admin' and !pass

        user.password = pass
        user.groups = 'admin'

        user.save setupFinish
      else
        console.log 'creating user'
        return setupFinish 'Must set a password when creating a new account.' unless pass
        User.register {email:email, password:pass, groups:'admin'}, setupFinish

  setupFinish = (err, user) ->
    console.log 'setupFinish', err, user.email, user.groups
    return if err
    dbconnect.db_mongo.close()

option '-p', '--port [PORT]', "listen on a specific port for `cake dev`"
task 'dev', 'Creates a new instance of zmgc.', (options) ->
  console.log 'dev options', options
  return console.log 'tzm-blade version ' + pkg.version if options.version
  # watch_coffee
  # options = ['-c', '-b', '-w', '-o', '.app', 'src']
  # cmd = which.sync 'coffee'  
  # coffee = spawn cmd, options
  # coffee.stdout.pipe process.stdout
  # coffee.stderr.pipe process.stderr
  log 'Watching coffee files', green
  # watch_js

  process.env.EMAIL = options.email if options.email
  process.env.PORT = options.port if options.port

  supervisor = spawn 'node', [
    './node_modules/supervisor/lib/cli-wrapper.js',
    '-w',
    'app,views',
    '-e',
    'js|blade',
    'run',
  ]
  supervisor.stdout.pipe process.stdout
  supervisor.stderr.pipe process.stderr
  log 'Watching js files and running server', green
  
task 'debug', 'start debug env', ->
  # watch_coffee
  options = ['-c', '-b', '-w', '-o', '.app', 'src']
  cmd = which.sync 'coffee'  
  coffee = spawn cmd, options
  coffee.stdout.pipe process.stdout
  coffee.stderr.pipe process.stderr
  log 'Watching coffee files', green
  # run debug mode
  app = spawn 'node', [
    '--debug',
    'run'
  ]
  app.stdout.pipe process.stdout
  app.stderr.pipe process.stderr
  # run node-inspector
  inspector = spawn 'node-inspector'
  inspector.stdout.pipe process.stdout
  inspector.stderr.pipe process.stderr
  # run google chrome
  chrome = spawn 'google-chrome', ['http://0.0.0.0:8080/debug?port=5858']
  chrome.stdout.pipe process.stdout
  chrome.stderr.pipe process.stderr
  log 'Debugging server', green
  
option '-n', '--name [NAME]', 'name of model to `scaffold`'
task 'scaffold', 'scaffold model/controller/test', (options) ->
  if not options.name?
    log "Please specify model name", red
    process.exit(1)
  log "Scaffolding `#{options.name}`", green
  scaffold = require './scaffold'
  scaffold options.name
