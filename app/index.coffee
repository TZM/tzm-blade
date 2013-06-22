#Load external dependencies
express = require "express"
stylus = require "stylus"
mongoose = require "mongoose"
i18next = require "i18next"
#Load local dependencies
config = require "./config/config"
models = require "./config/models"
apps = require "./config/apps"
routes = require "./config/routes"
# passport = require "passport"
# riak = require('riak-js').getClient(
#   host: config.RIAK_DB.host, 
#   port: config.RIAK_DB.port, 
#   debug: true)

# console.log "riak hostname: ", config.RIAK_DB.host
# console.log "riak port: ", config.RIAK_DB.port

#Load and intitialize logger
logger = require "./utils/logger"
logCategory = "APP config"
flash = require "connect-flash"

# Create server and set environment
app = express()
app.configure ->
  app.use( flash() )
#   app.use(passport.initialize())
#   app.use(passport.session())
#   app.use(require "./config/passport")

app.configure "production", "development", "test", ->
  config.setEnvironment app.settings.env
  console.log 'environment is: ', app.settings.env


# TODO store log messages in the RIAK db
logger.configure()
logger.info "--- App server created and local env set to: "+app.settings.env+" ---", logCategory

#Define Port
app.port = config.PORT
logger.info "--- Server running on port: "+app.port+" --- ", logCategory

#Connect to database
dbconnection = require "./utils/dbconnect"
dbconnection.init (result) ->
  if result
    logger.info "Database initialized: " + result, logCategory

#Exports
module.exports = ->
  
  #  Load Mongoose Models
  models app
  # Init i18next
  i18next.init(config.I18N)
  # Load Expressjs config
  apps app
  #  Load routes config
  routes app
  # 
  app
# register i18next helpers


i18next.registerAppHelper(app)
logger.info "--- Modules loaded into namespace ---", logCategory

