express = require "express"
csrf = express.csrf()
gzippo = require "gzippo"
assets = require "connect-assets"
jsPaths = require "connect-assets-jspaths"
#stylus = require "stylus"
blade = require "blade"
#mongoose = require "mongoose"
i18n = require "i18next"
http = require "http"
https = require "https"
fs = require "fs"
json = ""
##{Recaptcha} = require 'recaptcha'

logger = require "./utils/logger"
# Initialize logger
logger.configure()

dbconnection = require "./utils/dbconnect"

#### Application initialization
# Create app instance.
app = express()
# Define Port
app.port = process.env.PORT or process.env.VMC_APP_PORT or process.env.VCAP_APP_PORT or 3000

# Config module exports has `setEnvironment` function that sets app settings depending on environment.
config = require "./config"

logCategory = "Server"

app.configure "production", "development", "testing", ->
  config.setEnvironment app.settings.env

console.log(app)
# Database connection
dbconnection.initialize (result) ->
  "use strict"
  if result
    logger.info "Database initialized", logCategory
  else
    logger.error "Database not initialized " + result + ". ", logCategory
    process.exit 1

# i18next init
i18n.init(config.I18N)

#### View initialization 
# Add Connect Assets.
app.use assets(build : true)
logger.info "Loading assets...", logCategory
jsPaths assets, console.log
#app.use i18n.init
# Set the public folder as static assets.
app.use gzippo.staticGzip(process.cwd() + "/assets")
app.use gzippo.staticGzip(process.cwd() + "/public")
app.use express.favicon(process.cwd() + "/assets/images/favicon.ico")
app.use express.logger('dev')
# Set the nowjs folder as static assets and locales for i18next
app.use gzippo.staticGzip(process.cwd() + "/nowjs")
app.use gzippo.staticGzip(process.cwd() + "/locales")
app.use gzippo.staticGzip(process.cwd() + "/data/topo")

# Set Blade View Engine and tell Express where our views are stored
app.set "view engine", "blade"
app.set "views", process.cwd() + "/views"


try
  app.set "chapters", require(process.cwd() + "/data/chapters.json")
  app.set "languages", require(process.cwd() + "/locales/config.json")
  app.set "translation", require(process.cwd() + "/locales/dev/translation.json")
catch e
  console.warn "files not found: " + e
  app.set "chapters", []
  app.set "languages", []
  app.set "translation", []
  next()
  return

# [Body parser middleware](http://www.senchalabs.org/connect/middleware-bodyParser.html) parses JSON or XML bodies into `req.body` object
app.use express.bodyParser()
app.use express.methodOverride()
app.use express.cookieParser()
app.use express.session
  # You should probably add some sort of store
  # Use connect-mongo or connect-redis
  secret: 'this is your call, buddy'
app.use (req, res, next) ->
  # Only use CSRF if user is logged in
  if req.session.userId
    csrf req, res, next
  else
    next()
app.use i18n.handle
app.use blade.middleware(process.cwd() + "/views")

# Initialize routes
routes = require "./routes"

routes(app)
app.use app.router
#app.use require('./routes/user').middleware
#app.use '/api/v1', require('./routes/api').middleware

#### Finalization
# Register i18next AppHelper so we can use the translate function in template
i18n.registerAppHelper(app)
app.locals.pretty=true

# Export application object
module.exports = app