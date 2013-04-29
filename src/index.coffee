express = require "express"
assets = require "connect-assets"
stylus = require "stylus"
blade = require "blade"
#mongoose = require "mongoose"
i18n = require "i18next"
http = require "http"
https = require "https"
fs = require "fs"
json = ""

#### Application initialization
# Create app instance.
app = express()

# Define Port
app.port = process.env.PORT or process.env.VMC_APP_PORT or process.env.VCAP_APP_PORT or 3000


# Config module exports has `setEnvironment` function that sets app settings depending on environment.
config = require "./config"
app.configure "production", "development", "testing", ->
  config.setEnvironment app.settings.env

# db_config = "mongodb://#{config.DB_USER}:#{config.DB_PASS}@#{config.DB_HOST}:#{config.DB_PORT}/#{config.DB_NAME}"
# mongoose.connect db_config
#if app.settings.env != "production"
#  mongoose.connect "mongodb://localhost/example"
#else
#  console.log("If you are running in production, you may want to modify the mongoose connect path")

#i18n.configure =
#  detectLngQS: "lang"
#  ,resSetPath: "./locales/__lng__/translation.json"
#  ,ignoreRoutes: ["images/", "public/", "css/", "js/"]
#  ,locales:['de', 'en', 'fr', 'pt']
#  ,extension:".json"
#  ,saveMissing: true
#  ,debug: false
  
# i18next init
i18n.init
  detectLngQS: "lang"
  ,ns: { namespaces: ['ns.common', 'ns.layout'], defaultNs: 'ns.common'}
  #,resSetPath: "./locales/__lng__/translation.json"
  ,resSetPath: "./locales/__lng__/new.__ns__.json"
  ,ignoreRoutes: ["images/", "public/", "css/", "js/"]
  #,locales:['de', 'en', 'fr', 'pt']
  ,extension:".json"
  #,saveMissing: true
  #,sendMissingTo: 'all'
  ,debug: true


#### View initialization 
# Add Connect Assets.
app.use assets()
#app.use i18n.init
# Set the public folder as static assets.
app.use express.static(process.cwd() + "/public")
app.use express.favicon(process.cwd() + "/public/images/favicon.ico")
# Set the nowjs folder as static assets and locales for i18next
app.use express.static(process.cwd() + "/nowjs")
app.use express.static(process.cwd() + "/locales")

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

app.use i18n.handle
app.use blade.middleware(process.cwd() + "/views")
app.use app.router

#### Finalization
# Register i18next AppHelper so we can use the translate function in template
i18n.registerAppHelper(app)

# Initialize routes
routes = require "./routes"
app.locals.pretty=true
routes(app)

# Export application object
module.exports = app