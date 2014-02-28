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

option '-a', '--admin [ADMIN]', "Create a new admin account or upgrade existing one"
option '-w', '--password [PASSWORD]', 'Flag to overwrite any existing password'
task 'setup', 'Create a new administrator account', (options) ->
  return console.log 'Set the -a flag to setup a new admin' unless options.admin

  prompt = require 'prompt'

  pEma =
    name:'email'
    validator: /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/
    warning: 'Email must match the email@domain.tld format'
  pPas =
    name:'password', hidden:true
    validator: /.{6}/
    warning: 'Password must be at least 6 characters long'

  args = [];
  pass = options.password
  email = options.admin

  if typeof email is 'string'
    return console.log pEma.warning unless email.match pEma.validator
  else
    args.push pEma;

  if typeof pass is 'string'
    return console.log pPas.warning unless pass.match pPas.validator
  else if pass
    args.push pPas

  dbconnect = require './app/utils/dbconnect'

  prompt = false

  handleInput = (err, result) ->
    email = result.email.toLowerCase()
    pass = result.password

    dbconnect.init (err) ->
      return console.log 'setup error', err if err
      User = require './app/models/user/user'

      User.findOne {email:email}, (err, user) ->
        return setupFinish err if err

        if user
            return setupFinish null, user if user.groups is 'admin' and user.active and !pass

            user.groups = 'admin'
            user.password = pass if pass
            user.active = true

            return user.save setupFinish

          else
            console.log 'creating user'
            obj = {email:email, password:pass, groups:'admin', active:true}
            return User.register obj, setupFinish if pass

            return setupFinish new Error('Password required when creating new user') unless pass

            prompt.get [pPas], (err, result) ->
              return setupFinish err if err

              pass = obj.password = result.password
              User.register obj, setupFinish

  if args.length
    prompt = require 'prompt'
    prompt.start()
    prompt.get args, handleInput
  else
    handleInput null, email:email, password:pass

  setupFinish = (err, user) ->
    console.log 'setup error', err.message+err.stack || err if err
    dbconnect.db_mongo?.close()
    return if err

    msg = 'user '+user.email+' is now '+user.groups
    msg += ': password set' if pass
    console.log msg

option '-v', '--version', "show app's version number"
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
